# https://kubernetes.io/docs/concepts/storage/storage-classes/
resource "kubernetes_storage_class" "efs-sc" {
  metadata {
    name = "efs-sc"
  }
  storage_provisioner = "efs.csi.aws.com"
  parameters = {
    # https://github.com/kubernetes-sigs/aws-efs-csi-driver/tree/master/examples/kubernetes/dynamic_provisioning
    provisioningMode = "efs-ap"
    fileSystemId     = data.terraform_remote_state.state.outputs.efs_file_system_id
    directoryPerms   = "755" # 700   
  }
  depends_on = [
    helm_release.aws-efs-csi-driver
  ]
}

resource "kubernetes_persistent_volume_claim" "wp-content" {
  metadata {
    name = "wp-content-pvc"
  }
  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = "efs-sc"
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
  depends_on = [
    helm_release.aws-efs-csi-driver
  ]
}
