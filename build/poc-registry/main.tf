provider "google" {
  # Configure the Google provider
  project = "tao-artefacts"
  region  = "europe-west1"
}

resource "google_service_account" "oss_poc_sa" {
  account_id   = "oss-poc-pull-only"
  display_name = "Service Account for OSS Read-Only Access"
}

resource "google_artifact_registry_repository_iam_member" "oss_poc_sa_role" {
  project = "tao-artefacts"
  role    = "roles/artifactregistry.reader"
  repository = "tao-ce-poc"
  location = "europe-west1"
  member  = "serviceAccount:${google_service_account.oss_poc_sa.email}"
}

resource "google_service_account_key" "oss_poc_key" {
  service_account_id = google_service_account.oss_poc_sa.name
}

resource "local_file" "gar_reader_key_file" {
  content  = base64decode(google_service_account_key.oss_poc_key.private_key)
  filename = "gar-reader-key.json"
}