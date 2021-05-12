apiVersion: v1
kind: Pod
metadata:
  name: init-sample
spec:
  containers:
  - name: main           # 메인 컨테이너
    image: ubuntu
    command: ["/bin/sh"]
    args: [ "-c", "tail -f /dev/null"]
    volumeMounts:
    - mountPath: /docs   # 공유 볼륨 마운트 경로
      name: data-vol
      readOnly: false

  initContainers:        # 메인 컨테이너 실행 전에 초기화 전용 컨테이너를 기동 
  - name: init
    image: alpine
    ## 공유 볼륨에 디렉터리를 작성하고, 소유를 변경
    command: ["/bin/sh"]
    args: [ "-c", "mkdir /mnt/html; chown 33:33 /mnt/html" ]
    volumeMounts:
    - mountPath: /mnt    # 공유 볼륨 마운트 경로 
      name: data-vol
      readOnly: false

  volumes:               # 파드의 공유 볼륨
  - name: data-vol
    emptyDir: {}
