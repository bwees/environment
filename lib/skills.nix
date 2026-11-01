{ config, lib, ... }:

let
  cfg = config.skills;
  customDir = ../dotfiles/skills;

  customNames = lib.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir customDir));
  custom = lib.genAttrs customNames (name: "skills/${name}");
  external = lib.listToAttrs (map (path: lib.nameValuePair (builtins.unsafeDiscardStringContext (baseNameOf path)) path) cfg.external);

  duplicates = lib.intersectLists customNames (lib.attrNames external);
  missing = lib.filter (path: !builtins.pathExists "${path}/SKILL.md") cfg.external;
  allSkills = custom // external;
in
{
  options.skills = {
    external = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Skill directories from flake inputs. The directory name becomes the skill name.";
    };

    targets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        ".agents/skills"
        ".claude/skills"
      ];
      description = "Home-relative directories that agents load skills from.";
    };
  };

  config = {
    assertions = [
      {
        assertion = duplicates == [ ];
        message = "skills defined both in dotfiles/skills and skills.external: ${toString duplicates}";
      }
      {
        assertion = missing == [ ];
        message = "skills.external paths without a SKILL.md: ${toString missing}";
      }
    ];

    dotfiles.links = lib.mkMerge (
      map (target: lib.mapAttrs' (name: source: lib.nameValuePair "${target}/${name}" source) allSkills) cfg.targets
    );
  };
}
