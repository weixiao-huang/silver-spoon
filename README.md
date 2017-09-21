# x86 AT&T assembly environment in docker

---

## 介绍

这是一个用docker实现的x86 AT&T汇编环境

## 使用

第一次使用，请运行

```
$ make init
```

来下载并初始化镜像。

之后使用

```
$ make
```

来进入容器（虚拟机），此时既可以在容器中开发汇编。