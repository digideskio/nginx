#!/bin/bash

cat > nginx-rc.yaml << EOF
 apiVersion: v1
 kind: ReplicationController
 metadata:
   name: nginx
   labels:
     name: nginx
   namespace: dev
 spec:
   replicas: 1
   selector:
     name: nginx
     deployment: ${WERCKER_GIT_COMMIT}
   template:
     metadata:
       labels:
         name: nginx
         deployment: ${WERCKER_GIT_COMMIT}
     spec:
       containers:
         - name: nginx
           image: ${TUTUM_REPO}:${WERCKER_GIT_COMMIT}
           env:
             - name: ENABLE_SSL
               value: "true"
           ports:
             - name: http
               containerPort: 80
             - name: https
               containerPort: 443
           volumeMounts:
             - name: nginx-env
               mountPath: /etc/nginx-env
               readOnly: true
       imagePullSecrets:
         - name: tutum-registry-config
       volumes:
         - name: nginx-env
           secret:
             secretName: nginx-env
EOF
