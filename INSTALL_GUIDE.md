# easyblup 安装和故障排除指南

## 📦 安装方法

### 推荐方法：安装到用户库（避免权限问题）

```r
# 1. 确保 remotes 包已安装
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}

# 2. 设置用户库路径
user_lib <- Sys.getenv("R_LIBS_USER")
if (!dir.exists(user_lib)) {
  dir.create(user_lib, recursive = TRUE)
}

# 3. 从 GitHub 安装
remotes::install_github("Thymine2001/easyblup", lib = user_lib)

# 4. 加载并使用
library(easyblup)
easyblup::run_easyblup()
```

### 标准安装方法

```r
# 如果有管理员权限，可以直接安装
remotes::install_github("Thymine2001/easyblup")
library(easyblup)
easyblup::run_easyblup()
```

## 🔧 常见问题和解决方案

### 问题 1: "failed to lock directory" 错误

**错误信息：**
```
ERROR: failed to lock directory '/Library/Frameworks/R.framework/...' for modifying
Try removing '/Library/Frameworks/R.framework/.../00LOCK-easyblup'
```

**解决方案：**

**方法 A - 在 R 中清理（推荐）：**
```r
# 清理所有锁定文件
unlink(list.files(.libPaths(), pattern = "^00LOCK", 
       full.names = TRUE, recursive = TRUE), 
       recursive = TRUE, force = TRUE)

# 重新安装
remotes::install_github("Thymine2001/easyblup", force = TRUE)
```

**方法 B - 在终端中清理（需要 sudo）：**
```bash
sudo rm -rf '/Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/library/00LOCK-easyblup'
```

**方法 C - 安装到用户目录（避免权限问题）：**
```r
user_lib <- Sys.getenv("R_LIBS_USER")
if (!dir.exists(user_lib)) dir.create(user_lib, recursive = TRUE)
remotes::install_github("Thymine2001/easyblup", lib = user_lib)
```

### 问题 2: "不支持的扩展名" 错误

**错误信息：**
```
Error in FUN(X[[i]], ...) : 不支持的扩展名：
```

**原因：**
这是 v0.1.0 版本的已知问题，已在 v0.1.1 中修复。

**解决方案：**
```r
# 更新到最新版本
remotes::install_github("Thymine2001/easyblup", force = TRUE)

# 验证版本
packageVersion("easyblup")  # 应该显示 0.1.1 或更高
```

### 问题 3: 函数名称错误 "could not find function 'run_easyblup'"

**解决方案：**
确保使用正确的函数名和命名空间：

```r
# 正确的调用方式
library(easyblup)
run_easyblup()  # 或
easyblup::run_easyblup()

# 检查函数是否导出
ls("package:easyblup")
```

## ✅ 验证安装

运行以下脚本验证安装：

```r
# 验证脚本
library(easyblup)

# 1. 检查版本
cat("版本:", as.character(packageVersion("easyblup")), "\n")

# 2. 检查函数
if (exists("run_easyblup", where = "package:easyblup")) {
  cat("✅ run_easyblup 函数可用\n")
} else {
  cat("❌ 函数未找到\n")
}

# 3. 检查应用文件
app_dir <- system.file("shiny_app", package = "easyblup")
cat("应用目录:", app_dir, "\n")
cat("文件列表:\n")
print(list.files(app_dir))
```

## 🚀 使用方法

### 基本用法

```r
library(easyblup)
easyblup::run_easyblup()
```

### 自定义启动参数

```r
# 指定端口
easyblup::run_easyblup(port = 8080)

# 不自动打开浏览器
easyblup::run_easyblup(launch.browser = FALSE)

# 指定主机
easyblup::run_easyblup(host = "0.0.0.0", port = 3838)
```

## 📝 支持的文件格式

### 表型数据
- **支持格式**: `.csv`, `.txt`, `.dat`
- **要求**: 必须包含列名（第一行为变量名）
- **分隔符**: CSV 用逗号，TXT/DAT 用空格或制表符

### 系谱数据
- **支持格式**: `.txt`, `.ped`
- **格式**: Progeny Sire Dam（3列）

### 基因型数据
- **支持格式**: PLINK `.ped` 和 `.map` 文件
- **要求**: 必须同时上传两个文件

## 🌐 在线版本

如果本地安装遇到问题，可以使用在线版本：

**在线演示**: https://vb6clt-huangyi-tang.shinyapps.io/easyblup/

## 📧 获取帮助

如果遇到其他问题：

1. **查看文档**: `?run_easyblup`
2. **GitHub Issues**: https://github.com/Thymine2001/easyblup/issues
3. **检查日志**: 运行应用时查看 R 控制台的错误信息

## 📌 版本历史

- **v0.1.1** (2025-10-12)
  - ✅ 修复"不支持的扩展名"错误
  - ✅ 增强文件格式验证
  - ✅ 改进错误提示信息
  
- **v0.1.0** (2025-09-14)
  - 🎉 首次发布
