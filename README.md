### Ops Server（跳板机）

### jump.sh
  - 里面使用了 sudo -u ops, 所以需要设置 sudo
    创建一个组，这个组内的用户可以执行 ssh 指令
    例如：
      groupadd mg_group   # 运维组
      useradd fifor       # 运维用户
      visudo  # 添加
        Cmnd_Alias LOGIN_CMD = /bin/ssh
        %mg_group       ALL=(ops) NOPASSWD: LOGIN_CMD
      gpasswd -a fifor mg_group

### 注意
  - 脚本只适合 bash 解释器

### ChangeLog
  - 0.0.2
    添加 Host Name 列
