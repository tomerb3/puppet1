#class test::params will get all the details from hiera
class test::params {
  $env_details = hiera_hash('environments')
  $artifact_path = hiera('ArtifactPath')
}
