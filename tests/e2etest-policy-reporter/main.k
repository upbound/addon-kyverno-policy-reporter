import models.io.upbound.dev.meta.v1alpha1 as metav1alpha1
import models.io.k8s.api.rbac.v1 as rbacv1
import file

version = file.read_env("UP_CHART_VERSION")
_items = [
    metav1alpha1.E2ETest{
        metadata.name: "addon-kyverno-policy-reporter"
        spec= {
            crossplane.autoUpgrade.channel: "Rapid"
            defaultConditions: ["Installed", "Healthy"]
            initResources: [
                rbacv1.ClusterRoleBinding{
                    metadata.name: "upbound-controller-manager-cluster-admin"
                    roleRef: {
                        apiGroup: "rbac.authorization.k8s.io"
                        kind: "ClusterRole"
                        name: "cluster-admin"
                    }
                    subjects: [
                        {
                            kind: "ServiceAccount"
                            name: "upbound-controller-manager"
                            namespace: "crossplane-system"
                        }
                    ]
                }
                {
                    apiVersion: "apiextensions.k8s.io/v1"
                    kind: "CustomResourceDefinition"
                    metadata.name: "policyreports.wgpolicyk8s.io"
                    spec: {
                        group: "wgpolicyk8s.io"
                        names: {
                            kind: "PolicyReport"
                            listKind: "PolicyReportList"
                            plural: "policyreports"
                            singular: "policyreport"
                            shortNames: ["polr"]
                        }
                        scope: "Namespaced"
                        versions: [{
                            name: "v1alpha2"
                            served: True
                            storage: True
                            schema.openAPIV3Schema: {
                                type: "object"
                                "x-kubernetes-preserve-unknown-fields": True
                            }
                        }]
                    }
                }
                {
                    apiVersion: "apiextensions.k8s.io/v1"
                    kind: "CustomResourceDefinition"
                    metadata.name: "clusterpolicyreports.wgpolicyk8s.io"
                    spec: {
                        group: "wgpolicyk8s.io"
                        names: {
                            kind: "ClusterPolicyReport"
                            listKind: "ClusterPolicyReportList"
                            plural: "clusterpolicyreports"
                            singular: "clusterpolicyreport"
                            shortNames: ["cpolr"]
                        }
                        scope: "Cluster"
                        versions: [{
                            name: "v1alpha2"
                            served: True
                            storage: True
                            schema.openAPIV3Schema: {
                                type: "object"
                                "x-kubernetes-preserve-unknown-fields": True
                            }
                        }]
                    }
                }
                {
                    apiVersion: "pkg.upbound.io/v1beta1"
                    kind: "AddOnRuntimeConfig"
                    metadata: {
                        name: "policy-reporter-e2e"
                    }
                    spec: {
                        helm: {
                            values: {
                                plugin: {
                                    kyverno: {
                                        enabled: False
                                    }
                                }
                            }
                        }
                    }
                }
            ]
            manifests: [
                {
                    apiVersion: "pkg.upbound.io/v1beta1"
                    kind: "AddOn"
                    metadata: {
                        name: "pkg-addon-kyverno-policy-reporter"
                    }
                    spec: {
                        package: "xpkg.upbound.io/upbound/addon-kyverno-policy-reporter:"+ version
                        runtimeConfigRef: {
                            apiVersion: "pkg.upbound.io/v1beta1"
                            kind: "AddOnRuntimeConfig"
                            name: "policy-reporter-e2e"
                        }
                    }
                }
            ]
            extraResources: []
            skipDelete: False
            timeoutSeconds: 4500
        }
    }
]
items= _items
