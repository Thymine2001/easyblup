# easyblup 安装和使用指南

## 项目简介

easyblup 是一个用于生成 BLUPF90 参数文件的可视化 Shiny 应用程序。通过拖拽界面，用户可以轻松定义线性混合模型并自动生成 renumf90 参数文件。

## 安装步骤

### 1. 下载项目

#### 方法一：使用 Git（推荐）
```bash
git clone https://github.com/Thymine2001/easyblup.git
cd easyblup
```

#### 方法二：直接下载
1. 访问 https://github.com/Thymine2001/easyblup
2. 点击绿色的 "Code" 按钮
3. 选择 "Download ZIP"
4. 解压到本地文件夹

### 2. 安装 R 和 RStudio

#### 安装 R
- **Windows**: 访问 https://cran.r-project.org/bin/windows/base/
- **macOS**: 访问 https://cran.r-project.org/bin/macosx/
- **Linux**: 使用包管理器安装，如 `sudo apt-get install r-base`

#### 安装 RStudio（推荐）
- 访问 https://www.rstudio.com/products/rstudio/download/
- 下载并安装 RStudio Desktop

### 3. 安装必需的 R 包

打开 R 或 RStudio，运行以下命令：

```r
# 安装必需的包
install.packages(c("shiny", "sortable", "shinyjqui"), 
                 repos = "https://cran.rstudio.com/")

# 验证安装
library(shiny)
library(sortable)
library(shinyjqui)
```

## 使用方法

### 方法一：在 RStudio 中运行

1. 打开 RStudio
2. 打开项目文件 `easyblup.Rproj`
3. 在 RStudio 中打开 `shiny_app/app.R` 或 `shiny_app/minimal_app.R`
4. 点击 "Run App" 按钮

### 方法二：在命令行中运行

```bash
# 进入项目目录
cd easyblup/shiny_app

# 运行应用
Rscript app.R
# 或者
Rscript minimal_app.R
```

### 方法三：在 R 中运行

```r
# 设置工作目录
setwd("path/to/easyblup/shiny_app")

# 运行应用
shiny::runApp("app.R")
```

## 使用步骤

### 1. 上传数据文件

- **表型数据**: 上传包含表型数据的文本文件（.txt, .dat, .csv）
  - 支持空格分隔的文本文件
  - 第一行应为列名
  - 示例文件：`example_data.csv`

- **系谱数据**（可选）: 上传系谱文件（.txt, .ped）
  - 格式：个体ID 父本ID 母本ID
  - 示例文件：`example_data.ped`

- **基因型数据**（可选）: 上传 PLINK 格式文件
  - .ped 文件：基因型数据
  - .map 文件：标记信息
  - 示例文件：`example_data.ped` 和 `example_data.map`

### 2. 定义模型

通过拖拽变量到相应的模型组件：

- **性状 (y)**: 拖拽响应变量
- **固定效应 (b)**: 拖拽固定效应变量
- **动物ID (a)**: 拖拽动物ID变量
- **其他随机效应 (r)**: 拖拽其他随机效应变量

### 3. 配置参数选项

在左侧面板中配置各种 BLUPF90 参数：

- **基本选项**: 缺失值处理、统计计算等
- **文件读取选项**: 字符字段大小、记录长度等
- **近交系数方法**: 选择计算方法
- **分析方法选项**: VCE、收敛标准等

### 4. 预览和下载

- 实时预览生成的参数文件
- 点击 "📥 Download Parameter File" 下载
- 确认后下载 `easyblup.par` 文件

## 部署到 shinyapps.io（可选）

如果您想将应用部署到云端：

### 1. 创建 shinyapps.io 账户

访问 https://www.shinyapps.io/ 注册免费账户

### 2. 获取账户信息

在账户设置中获取：
- Account name
- Token
- Secret

### 3. 配置并部署

```r
# 安装 rsconnect 包
install.packages("rsconnect")

# 配置账户
library(rsconnect)
rsconnect::setAccountInfo(
  name="your-account-name",
  token="your-token", 
  secret="your-secret"
)

# 部署应用
setwd("shiny_app")
source("deploy.R")
```

## 故障排除

### 常见问题

1. **包安装失败**
   ```r
   # 尝试使用不同的镜像
   install.packages("shiny", repos = "https://cloud.r-project.org/")
   ```

2. **应用无法启动**
   - 检查是否安装了所有必需的包
   - 确保工作目录正确
   - 查看错误信息并解决

3. **文件上传失败**
   - 检查文件格式是否正确
   - 确保文件大小不超过 10GB
   - 检查文件编码（建议使用 UTF-8）

4. **拖拽功能不工作**
   - 确保浏览器支持 JavaScript
   - 尝试刷新页面
   - 检查浏览器控制台是否有错误

### 获取帮助

- 查看项目文档：`README.md`, `USAGE.md`
- 提交问题：https://github.com/Thymine2001/easyblup/issues
- 查看示例数据了解格式要求

## 系统要求

- **R**: 版本 3.6.0 或更高
- **RStudio**: 版本 1.2 或更高（推荐）
- **浏览器**: 支持 JavaScript 的现代浏览器
- **内存**: 建议 4GB 或更多
- **存储**: 至少 100MB 可用空间

## 许可证

本项目使用 MIT 许可证。详见 `LICENSE` 文件。
