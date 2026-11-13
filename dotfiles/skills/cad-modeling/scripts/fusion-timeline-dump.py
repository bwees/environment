# Run through fusion_mcp_execute with featureType "script" and readOnly false.
# Rolls the timeline to each item to read history-only data, then restores the marker.

import adsk.core
import adsk.fusion

MM_PER_CM = 10
OPERATIONS = {0: "join", 1: "cut", 2: "intersect", 3: "new", 4: "new_component"}


def mm(value):
    return round(value * MM_PER_CM, 4)


def pt(p):
    return f"({mm(p.x)},{mm(p.y)},{mm(p.z)})"


def vec(v):
    return f"({v.x:.3f},{v.y:.3f},{v.z:.3f})"


def safe(read):
    try:
        return read()
    except Exception as error:
        return f"<{error}>"


def face_text(face):
    text = f"face {type(face.geometry).__name__} centroid={pt(face.centroid)} area={round(face.area * 100, 3)} body={face.body.name}@{face.body.parentComponent.name}"
    if isinstance(face.geometry, adsk.core.Plane):
        text += f" n={vec(face.geometry.normal)}"
    return text


def edge_midpoint(edge):
    evaluator = edge.evaluator
    _, start, end = evaluator.getParameterExtents()
    _, mid = evaluator.getPointAtParameter((start + end) / 2)
    return mid


def dump_sketch(sketch, out):
    plane = safe(lambda: getattr(sketch.referencePlane, "name", type(sketch.referencePlane).__name__))
    out.append(f" plane={plane} origin={pt(sketch.origin)} x={vec(sketch.xDirection)} y={vec(sketch.yDirection)}")
    for curve in sketch.sketchCurves:
        flags = (" C" if curve.isConstruction else "") + (" REF" if curve.isReference else "")
        if isinstance(curve, adsk.fusion.SketchLine):
            out.append(f"  line {pt(curve.startSketchPoint.geometry)}->{pt(curve.endSketchPoint.geometry)}{flags}")
        elif isinstance(curve, adsk.fusion.SketchCircle):
            out.append(f"  circle c={pt(curve.centerSketchPoint.geometry)} r={mm(curve.radius)}{flags}")
        elif isinstance(curve, adsk.fusion.SketchArc):
            out.append(f"  arc c={pt(curve.centerSketchPoint.geometry)} r={mm(curve.radius)} s={pt(curve.startSketchPoint.geometry)} e={pt(curve.endSketchPoint.geometry)}{flags}")
        else:
            out.append(f"  {type(curve).__name__}{flags}")
    for dimension in sketch.sketchDimensions:
        out.append(f"  dim {type(dimension).__name__} {safe(lambda: dimension.parameter.expression)}")
    out.append(f"  constraints={sketch.geometricConstraints.count} profiles={sketch.profiles.count} fully_constrained={sketch.isFullyConstrained}")


def dump_extent(name, extent, out):
    if extent is None:
        return
    if isinstance(extent, adsk.fusion.DistanceExtentDefinition):
        out.append(f"  {name} distance {extent.distance.expression}")
    elif isinstance(extent, adsk.fusion.SymmetricExtentDefinition):
        out.append(f"  {name} symmetric {extent.distance.expression} full={extent.isFullLength}")
    elif isinstance(extent, adsk.fusion.ToEntityExtentDefinition):
        target = face_text(extent.entity) if isinstance(extent.entity, adsk.fusion.BRepFace) else type(extent.entity).__name__
        out.append(f"  {name} to {target} offset={safe(lambda: extent.offset.expression)}")
    else:
        out.append(f"  {name} {type(extent).__name__}")


def dump_extrude(extrude, out):
    participants = safe(lambda: [f"{b.name}@{b.parentComponent.name}" for b in extrude.participantBodies])
    out.append(f" op={OPERATIONS.get(extrude.operation, extrude.operation)} participants={participants}")
    profiles = extrude.profile if isinstance(extrude.profile, adsk.core.ObjectCollection) else [extrude.profile]
    for profile in profiles:
        if isinstance(profile, adsk.fusion.BRepFace):
            out.append(f"  profile {face_text(profile)}")
        else:
            box = profile.boundingBox
            out.append(f"  profile sketch={profile.parentSketch.name} bb={pt(box.minPoint)}..{pt(box.maxPoint)}")
    dump_extent("extentOne", extrude.extentOne, out)
    dump_extent("extentTwo", extrude.extentTwo, out)
    if isinstance(extrude.extentDefinition, adsk.fusion.SymmetricExtentDefinition):
        dump_extent("extent", extrude.extentDefinition, out)


def dump_edge_sets(feature, out):
    for edge_set in feature.edgeSets:
        size = next((safe(lambda a=a: getattr(edge_set, a).expression) for a in ("radius", "distance", "distanceOne") if hasattr(edge_set, a)), "?")
        out.append(f"  {type(edge_set).__name__} size={size}")
        for edge in safe(lambda: list(edge_set.edges)) or []:
            out.append(f"    edge mid={pt(edge_midpoint(edge))} len={mm(edge.length)} body={edge.body.name}@{edge.body.parentComponent.name}")


def dump_plane(plane, out):
    geometry = plane.geometry
    out.append(f"  {type(plane.definition).__name__} origin={pt(geometry.origin)} normal={vec(geometry.normal)}")


def dump_timeline(design, out):
    timeline = design.timeline
    out.append(f"marker={timeline.markerPosition} units=mm")
    for parameter in design.userParameters:
        out.append(f"param {parameter.name} = {parameter.expression}")
    for index in range(timeline.markerPosition):
        item = timeline.item(index)
        if item.isGroup:
            continue
        item.rollTo(True)
        entity = item.entity
        component = safe(lambda: entity.parentComponent.name)
        out.append(f"\n[{index}] {item.name} ({type(entity).__name__}) component={component}")
        if isinstance(entity, adsk.fusion.Sketch):
            dump_sketch(entity, out)
        elif isinstance(entity, adsk.fusion.ExtrudeFeature):
            dump_extrude(entity, out)
        elif isinstance(entity, (adsk.fusion.FilletFeature, adsk.fusion.ChamferFeature)):
            dump_edge_sets(entity, out)
        elif isinstance(entity, adsk.fusion.ConstructionPlane):
            dump_plane(entity, out)


def dump_multi_body_features(design, out):
    out.append("\n== features per component (one timeline index listed under several components = multi-body feature)")
    for component in design.allComponents:
        indexed = [(f.timelineObject.index, f.name) for f in component.features if f.timelineObject]
        if indexed:
            out.append(f"{component.name}: {sorted(indexed)}")


def dump_bodies(design, out):
    out.append("\n== bodies")
    for component in design.allComponents:
        for body in component.bRepBodies:
            props = body.physicalProperties
            box = body.boundingBox
            out.append(f"{component.name}/{body.name} vol={round(props.volume * 1000, 3)} faces={body.faces.count} bb={pt(box.minPoint)}..{pt(box.maxPoint)} com={pt(props.centerOfMass)}")


def run(_context: str):
    design = adsk.fusion.Design.cast(adsk.core.Application.get().activeProduct)
    marker = design.timeline.markerPosition
    out = []
    try:
        dump_timeline(design, out)
    finally:
        design.timeline.markerPosition = marker
    dump_multi_body_features(design, out)
    dump_bodies(design, out)
    print("\n".join(out))
