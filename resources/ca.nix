{ ... }:
{
  system.activationScripts.postActivation.text = ''
    echo "installing root CA certificates..."

    CERT_DATA="
      -----BEGIN CERTIFICATE-----
      MIIDGTCCAgGgAwIBAgIUNEdp+psSfglA6crbvxuf/WZWf8owDQYJKoZIhvcNAQEL
      BQAwHDEaMBgGA1UEAwwRYndlZXMgSW50ZXJuYWwgQ0EwHhcNMjUwMjA5MDI1OTM0
      WhcNMzUwMjA3MDI1OTM0WjAcMRowGAYDVQQDDBFid2VlcyBJbnRlcm5hbCBDQTCC
      ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALSdR/O1OsHvxnRt1xPSzBe8
      3u7un0AKWamf62MAu49VCTUvdFslegc/g+cRb+bMQIiLjjKTYaBuy2NCsfjhCNq1
      2mq9A1RkJZgFkMD3QvdC70Xfd4zGMUlNg/Aoj7HXotZMzVx0LOkh2zyLhRu7f3XE
      b+KC8DDmPZMBIMVlWxqnglNvgga9Tpil6qPgTImicEYI2CAkgi3EwZ/oWmwlKIwI
      EQy6HB+cYQ4+TAJjzVgJT6Rc1m5YEEMbE3wMc9Fcqy/tYxtmFSsMZKynQdCBfX/N
      zliVkBffSJp1yZCmzjRp1OfSYAf9M+8FKERpEymylrhwdUQO3PxRP30wJEKCoR0C
      AwEAAaNTMFEwHQYDVR0OBBYEFBTYF9BaaLcSq1wzsPH4hVgtfomPMB8GA1UdIwQY
      MBaAFBTYF9BaaLcSq1wzsPH4hVgtfomPMA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZI
      hvcNAQELBQADggEBAK5hkDdDAKUhqsigCciwjxrgeEc2GhG2NrgdLqhOd5NNXJWC
      1jP8gxQLHjeCol/PKqAB1E4sLS8ckAcBzt3nsq3z7WanA7qQYNu9DeMoNzyT8KN8
      kQn5SGq/gNBUWl7T8QjvWzAWceeuNztB7TsxVpXXp7XF2jzvAYKmrcO8AZTqIcI9
      WVlLNs9MP0hhA5NJXBpUGUvwjsihj078ktbHo3n1+gkk5/MjPRcv3Mjoa6W0/vFd
      IFklmGg3QXFkzExbttkCuHPTBwJVVrDGGLSDErX/JPAYxKKrKbnnm9ceBsGK7mdl
      SnVDRF55mYN450KtYWAj0T79Oj9flPFHow5/TEE=
      -----END CERTIFICATE-----
    "
    KEYCHAIN="/Library/Keychains/System.keychain"
    CA_NAME="bwees Internal CA"

    if ! security find-certificate -c "$CA_NAME" "$KEYCHAIN" >/dev/null 2>&1; then
      echo "$CERT_DATA" | security add-trusted-cert -d -r trustRoot -k "$KEYCHAIN" /dev/stdin
    fi

  '';
}
