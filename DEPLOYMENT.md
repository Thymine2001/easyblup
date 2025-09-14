# easyblup 部署指南

## 部署到 shinyapps.io

### 步骤 1: 创建 shinyapps.io 账户

1. 访问 https://www.shinyapps.io/
2. 点击 "Sign Up" 注册免费账户
3. 验证邮箱地址

### 步骤 2: 获取账户信息

1. 登录后，点击右上角头像
2. 选择 "Account Settings"
3. 点击 "Tokens" 标签
4. 点击 "Show" 按钮查看：
   - **Account name**: 您的账户名
   - **Token**: 您的token
   - **Secret**: 您的secret

### 步骤 3: 部署应用

#### 方法一：使用交互式脚本（推荐）

```bash
cd shiny_app
Rscript deploy_interactive.R
```

然后按提示输入您的账户信息。

#### 方法二：手动配置

在R中运行：

```r
# 安装rsconnect包
install.packages("rsconnect")

# 配置账户
library(rsconnect)
rsconnect::setAccountInfo(
  name = "your-account-name",
  token = "your-token", 
  secret = "your-secret"
)

# 部署应用
setwd("shiny_app")
deployApp(
  appDir = ".",
  appName = "easyblup",
  appTitle = "easyblup: Parameter File Generator for BLUPF90",
  appFiles = c("app.R", "example_data.csv", "example_data.map", "example_data.ped"),
  forceUpdate = TRUE
)
```

### 步骤 4: 访问应用

部署成功后，您的应用将在以下地址可用：
```
https://your-account-name.shinyapps.io/easyblup/
```

## 部署到其他平台

### 部署到 shinyapps.io 的替代方案

1. **RStudio Connect**: 企业级解决方案
2. **Shiny Server**: 自托管解决方案
3. **Docker**: 容器化部署

### 本地部署

如果您想在自己的服务器上部署：

1. 安装 Shiny Server
2. 将应用文件复制到服务器
3. 配置 Nginx 或其他反向代理

## 故障排除

### 常见问题

1. **认证失败**
   - 检查账户名、token和secret是否正确
   - 确保token没有过期

2. **部署失败**
   - 检查所有必需的包是否已安装
   - 确保应用文件完整

3. **应用无法访问**
   - 检查应用是否成功部署
   - 查看shinyapps.io的日志

### 获取帮助

- 查看shinyapps.io文档：https://docs.shinyapps.io/
- 提交问题到GitHub：https://github.com/Thymine2001/easyblup/issues
