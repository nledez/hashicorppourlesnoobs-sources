resource "tls_private_key" "le_tls_private_key" {
  algorithm = "RSA"
  rsa_bits  = "${var.le_account_key_size}"
}

resource "local_file" "le_tls_private_key_file" {
  content              = "${tls_private_key.le_tls_private_key.private_key_pem}"
  filename             = "${path.module}/${terraform.workspace}/le_account.key"
  file_permission      = "0600"
  directory_permission = "0755"
}

resource "acme_registration" "local_registration" {
  account_key_pem = "${tls_private_key.le_tls_private_key.private_key_pem}"
  email_address   = "${var.le_email}"
}

resource "acme_certificate" "certificate" {
  account_key_pem           = "${acme_registration.local_registration.account_key_pem}"
  common_name               = "*.${var.subdomain}.${var.parent_domain}"
  subject_alternative_names = ["${var.subdomain}.${var.parent_domain}"]
  key_type                  = "4096"

  dns_challenge {
    provider = "ovh"
  }
}

resource "local_file" "le_tls_private_key" {
  filename             = "${path.module}/${terraform.workspace}/le_tls_private_key.pem"
  content              = "${acme_certificate.certificate.private_key_pem}"
  file_permission      = "0600"
  directory_permission = "0755"
}

resource "local_file" "le_tls_certificate" {
  filename             = "${path.module}/${terraform.workspace}/le_tls_certificate.pem"
  content              = "${acme_certificate.certificate.certificate_pem}"
  file_permission      = "0644"
  directory_permission = "0755"
}

resource "local_file" "le_tls_issuer_certificate" {
  filename             = "${path.module}/${terraform.workspace}/le_tls_issuer_certificate.pem"
  content              = "${acme_certificate.certificate.issuer_pem}"
  file_permission      = "0644"
  directory_permission = "0755"
}

resource "local_file" "le_tls_chain_certificate" {
  filename             = "${path.module}/${terraform.workspace}/le_tls_chain_certificate.pem"
  content              = "${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}"
  file_permission      = "0644"
  directory_permission = "0755"
}
