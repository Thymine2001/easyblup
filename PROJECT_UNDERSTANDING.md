# easyblup 项目完整理解文档

## 📋 项目概览

**项目名称**: easyblup  
**类型**: R Shiny Web应用程序  
**用途**: BLUPF90参数文件可视化生成器  
**开发语言**: R  
**主要框架**: Shiny, sortable, shinyjqui  
**在线地址**: https://vb6clt-huangyi-tang.shinyapps.io/easyblup/

---

## 🎯 项目目的

easyblup旨在简化动物育种和遗传评估中BLUPF90软件的参数文件生成过程。通过直观的拖放界面，用户无需手动编写复杂的参数文件，即可：
- 定义线性混合模型
- 设置分析选项
- 生成标准的BLUPF90参数文件

---

## 📁 项目结构

```
easyblup/
├── 📄 核心文件
│   ├── README.md                    # 项目说明（英文）
│   ├── PROJECT_SUMMARY.md           # 项目总结（中文）
│   ├── USAGE.md                     # 详细使用说明（中文）
│   ├── INSTALLATION.md              # 安装指南
│   ├── DEPLOYMENT.md                # 部署说明
│   ├── DESCRIPTION                  # R包依赖配置
│   └── LICENSE                      # MIT许可证
│
├── 🚀 启动脚本
│   ├── quick_start.R                # 快速启动脚本
│   ├── run_easyblup.sh              # Unix/Linux启动脚本
│   └── run_easyblup.bat             # Windows启动脚本
│
├── 📱 Shiny应用目录 (inst/shiny_app/)
│   ├── app.R                        # 主应用文件 (1769行)
│   ├── minimal_app.R                # 简化版本
│   ├── minimal_app_backup.R         # 备份文件
│   │
│   ├── 📊 示例数据
│   │   ├── example_data.csv         # 表型数据示例
│   │   ├── example_data.ped         # 基因型数据(PED)
│   │   ├── example_data.map         # 基因型数据(MAP)
│   │   └── example_large_data.csv   # 大数据集示例
│   │
│   ├── 🚀 部署相关
│   │   ├── deploy.R                 # 自动部署脚本
│   │   ├── deploy_interactive.R     # 交互式部署
│   │   └── rsconnect/               # Shinyapps.io配置
│   │
│   └── README.md                    # 应用说明
│
└── 🔧 配置文件
    ├── R/run_easyblup.R             # 包入口函数
    ├── NAMESPACE                    # 导出设置
    ├── easyblup.Rproj               # RStudio项目配置
    ├── .gitignore                   # Git忽略文件
    ├── .Rbuildignore                # R构建忽略
    └── .Rproj.user/                 # RStudio用户设置
```

---

## 🧬 核心概念：线性混合模型

easyblup基于标准的动物模型线性混合模型：

```
y = Xb + Za + Wr + e
```

**其中**：
- **y**: 观测性状向量 (Traits)
- **X**: 固定效应设计矩阵
- **b**: 固定效应向量 (Fixed Effects)
- **Z**: 动物加性遗传效应设计矩阵
- **a**: 动物加性遗传效应向量 (Animal Effect)
- **W**: 其他随机效应设计矩阵
- **r**: 其他随机效应向量 (Random Effects)
- **e**: 残差向量 (Residual)

---

## 🎨 UI界面组件

### 1. 侧边栏 (Sidebar) - 数据上传区

**文件上传选项**：
- **表型数据** (.csv): 必需，最大10GB
- **血统文件** (.txt): 可选，BLUPF90格式
- **基因型数据** (.ped/.map): 可选，PLINK格式，最大10GB

**配色方案**：Purdue大学配色（黑金主题）

### 2. 主面板 (Main Panel) - 模型定义区

#### 2.1 可用变量区域
- 显示所有上传数据的列名
- 蓝色"药丸"样式按钮
- 可拖拽到模型组件

#### 2.2 模型组件区域（四个拖放区）

| 组件 | 颜色 | 图标 | 说明 |
|------|------|------|------|
| **Traits (y)** | 🟠 橙色 | 🧬 | 待分析的性状变量 |
| **Fixed Effects (b)** | 🔴 红色 | 📊 | 固定效应变量 |
| **Animal ID (a)** | 🟢 绿色 | 🐄 | 动物标识符 |
| **Random Effects (r)** | 🔵 蓝色 | 🎲 | 其他随机效应 |

#### 2.3 附加效应区域 (Additional Effects)
- **PE** (Permanent Environment): 永久环境效应
- **MAT** (Maternal): 母体效应
- **MPE** (Maternal PE): 母体永久环境效应

### 3. 参数选项区 (Parameter Options)

详细的BLUPF90+选项设置，包括：

#### 基础选项
- `remove_all_missing`: 移除所有缺失值
- `missing_in_weights`: 权重中的缺失值
- `no_basic_statistics`: 不显示基本统计

#### 文件读取选项
- `alpha_size`: 字母大小
- `max_string_readline`: 最大字符串读取长度
- `max_field_readline`: 最大字段读取数

#### 血统选项
- `inbreeding_method`: 近交系数计算方法
- `ped_search complete`: 完整血统搜索

#### 分析方法选项
- `method VCE`: 方差组分估计
- `sol se`: 解的标准误
- `conv_crit`: 收敛标准
- `EM-REML`: EM-REML迭代次数
- `use-yams`: 使用YAMS
- `tunedG2`: 调整G2
- `maxrounds`: 最大迭代次数

#### 解决方案输出选项
- `origID`: 使用原始ID
- `store_accuracy`: 存储准确性（自动计算animal effect编号）
- `acctype`: 准确性类型
- `correct_accuracy_by_inbreeding`: 按近交系数修正准确性

### 4. 参数文件预览区
- 实时显示生成的BLUPF90参数文件
- 可下载为.txt文件
- 支持复制粘贴

---

## 🔧 核心技术实现

### 1. 拖放功能 (sortable包)

```r
# 使用rank_list创建拖放区域
rank_list(
  text = "Traits (y)",
  labels = character(0),
  input_id = "traits",
  options = sortable_options(
    group = list(
      name = "shared_group",
      pull = TRUE,
      put = TRUE
    )
  )
)
```

### 2. 参数文件生成逻辑

应用包含**两个参数生成函数**：

#### 函数1: `output$param_output` (行1100-1417)
- 用于实时参数预览
- 响应式更新
- 显示在主界面

#### 函数2: `generate_parameter_content()` (行1457-1769)
- 用于文件下载
- 完整参数生成
- 与函数1保持同步

**关键生成步骤**：
1. 读取上传的数据文件
2. 获取拖放区域的变量列表
3. 计算列号映射
4. 生成DATAFILE、TRAITS、EFFECTS等部分
5. 处理OPTIONAL效应
6. 生成(CO)VARIANCES部分
7. 添加用户选择的OPTIONS

### 3. Animal Effect编号自动计算

```r
# 计算animal effect的位置
animal_effect_num <- reactive({
  n_traits <- length(values$traits)
  n_fixed <- length(values$fixed)
  n_random <- length(values$random)
  
  # animal effect编号 = traits数 + fixed数 + 1
  return(n_traits + n_fixed + 1)
})
```

### 4. 协方差矩阵生成逻辑

```r
# 根据是否有maternal effect决定矩阵结构
if (input$opt_mat) {
  # 有MAT时: 2x2矩阵
  param <- paste0(param, "1 0.01\n0.01 1\n")
} else {
  # 只有PE时: 单个值
  param <- paste0(param, "1\n")
}

# 独立的PE和MPE协方差
if (input$opt_pe) {
  param <- paste0(param, "(CO)VARIANCES_PE\n0.001\n")
}
if (input$opt_mpe) {
  param <- paste0(param, "(CO)VARIANCES_MPE\n0.003\n")
}
```

---

## 📊 数据流程

```
1. 用户上传数据 (CSV/PED/MAP)
        ↓
2. 系统读取并解析文件
        ↓
3. 提取列名并显示为可拖拽按钮
        ↓
4. 用户拖拽变量到模型组件
        ↓
5. 系统实时计算列号映射
        ↓
6. 用户选择参数选项
        ↓
7. 系统生成BLUPF90参数文件
        ↓
8. 用户预览、下载或复制参数文件
```

---

## 🎯 主要功能特性

### ✅ 已实现功能

1. **数据上传与处理**
   - CSV表型数据上传（最大10GB）
   - PLINK格式基因型数据上传
   - 血统文件上传
   - 自动列名识别

2. **可视化模型定义**
   - 拖放式交互
   - 四色编码的模型组件
   - 实时模型更新

3. **附加效应支持**
   - PE (永久环境效应)
   - MAT (母体效应)
   - MPE (母体永久环境效应)
   - 自动OPTIONAL部分生成

4. **BLUPF90+选项**
   - 30+个参数选项
   - 分类清晰的选项组
   - 智能默认值

5. **智能计算**
   - Animal effect编号自动计算
   - 列号自动映射
   - 协方差矩阵自动生成

6. **参数文件管理**
   - 实时预览
   - 一键下载
   - 格式化显示

7. **用户体验优化**
   - Purdue配色主题
   - 响应式设计
   - 清晰的视觉反馈
   - 可调整窗口大小

---

## 🔬 BLUPF90参数文件结构

### 标准参数文件格式

```
DATAFILE
data.csv

TRAITS
5 6 7

FIELDS_PASSED_TO_OUTPUT
5 6 7

WEIGHT(S)
# 如有需要添加权重列

EFFECTS
1 2 3 4    # 固定效应
8          # 动物ID
9          # 其他随机效应

RANDOM
animal
OPTIONAL
pe
mat
mpe
FILE
pedigree.txt
FILE_POS
1 2 3

(CO)VARIANCES
1 0.01
0.01 1

(CO)VARIANCES_PE
0.001

(CO)VARIANCES_MPE
0.003

OPTION remove_all_missing
OPTION missing -999
OPTION conv_crit 1d-12
OPTION maxrounds 1000000
OPTION origID
OPTION store_accuracy 5
...
```

### 协方差矩阵规则

| 情况 | (CO)VARIANCES | 说明 |
|------|---------------|------|
| 无MAT | `1` | 单个值 |
| 有MAT | `1 0.01`<br>`0.01 1` | 2x2矩阵 |
| 有PE | `(CO)VARIANCES_PE`<br>`0.001` | 独立部分 |
| 有MPE | `(CO)VARIANCES_MPE`<br>`0.003` | 独立部分 |

---

## 💻 技术栈

### R包依赖

| 包名 | 版本要求 | 用途 |
|------|---------|------|
| shiny | >= 1.7.0 | Web应用框架 |
| sortable | >= 0.4.2 | 拖放功能 |
| shinyjqui | >= 0.4.1 | UI增强 |

### 开发环境

- **R版本**: >= 3.6.0
- **推荐IDE**: RStudio
- **浏览器**: 现代浏览器（Chrome, Firefox, Safari, Edge）

---

## 🚀 运行方式

### 方式1: 使用已安装的包（推荐）
```r
easyblup::run_easyblup()
```
可通过向函数传递参数自定义端口、浏览器等，例如：
```r
easyblup::run_easyblup(port = 3259, launch.browser = TRUE)
```

### 方式2: 从源码目录运行
```bash
cd inst/shiny_app
Rscript app.R
```

### 方式3: R 控制台运行源码
```r
setwd("path/to/easyblup/inst/shiny_app")
shiny::runApp("app.R", port = 3259, host = "127.0.0.1")
```

### 方式4: 快速启动脚本
```bash
# Unix/Linux/Mac
./run_easyblup.sh

# Windows
run_easyblup.bat
```

### 方式5: 在线访问
访问: https://vb6clt-huangyi-tang.shinyapps.io/easyblup/

---

## 📝 代码结构（app.R文件组织）

```
app.R (1769行)
│
├── 行1-100: CSS样式定义
│   └── 自定义Purdue主题样式
│
├── 行101-700: UI定义
│   ├── 侧边栏: 文件上传
│   ├── 主面板: 
│   │   ├── 可用变量区
│   │   ├── 模型定义区
│   │   ├── 附加效应区
│   │   └── 参数选项区
│   └── 底部: 参数预览区
│
├── 行701-1100: Server函数 - 数据处理
│   ├── 文件读取逻辑
│   ├── 列名提取
│   ├── 响应式变量定义
│   └── Animal effect计算
│
├── 行1101-1420: Server函数 - 参数生成1
│   ├── output$param_output
│   ├── 实时预览生成
│   └── UI显示逻辑
│
├── 行1421-1456: Server函数 - 下载处理
│   └── downloadHandler定义
│
└── 行1457-1769: Server函数 - 参数生成2
    ├── generate_parameter_content()
    ├── 完整参数生成
    └── 文件下载逻辑
```

---

## 🎓 学习要点

### 对于R Shiny开发者

1. **拖放实现**: sortable包的使用
2. **响应式编程**: reactive和observe的应用
3. **大文件处理**: 10GB文件上传配置
4. **UI美化**: 自定义CSS主题
5. **代码组织**: 大型Shiny应用的结构

### 对于动物育种研究者

1. **BLUPF90参数**: 完整的参数文件结构
2. **模型定义**: 线性混合模型组件
3. **附加效应**: PE/MAT/MPE的含义和使用
4. **基因组分析**: PLINK格式数据处理

---

## 🔍 重要注意事项

### 1. 两个参数生成函数必须同步
- `output$param_output` (实时预览)
- `generate_parameter_content()` (文件下载)
- 修改时必须同时更新两处

### 2. 协方差矩阵生成逻辑
- 仅当有MAT效应时使用2x2矩阵
- PE和MPE总是独立的部分

### 3. Animal Effect编号
- 自动计算，无需手动输入
- 公式: n_traits + n_fixed + 1

### 4. 文件大小限制
- 单个文件: 10GB
- 需要在shiny-server配置中设置相应限制

---

## 🐛 已知问题和解决方案

### 问题1: 终端工作目录问题
**症状**: `Rscript -e "shiny::runApp()"` 找不到app.R

**解决方案**:
```r
R -e "easyblup::run_easyblup(port = 3259)"
```
或在源码目录下运行：
```r
R -e "setwd('/path/to/easyblup/inst/shiny_app'); shiny::runApp('app.R', port = 3259)"
```

### 问题2: 函数重复
**症状**: replace_string_in_file找到多个匹配

**解决方案**: 使用函数结尾的独特标识符
- 函数1: `return(param) })`
- 函数2: `return(param) }`

---

## 📈 未来改进方向

### 功能增强
- [ ] 支持更多文件格式（Excel, 文本）
- [ ] 模型验证功能
- [ ] 参数模板系统
- [ ] 批量文件处理
- [ ] 结果可视化

### 用户体验
- [ ] 多语言支持（中英文切换）
- [ ] 交互式教程
- [ ] 示例数据库
- [ ] 参数推荐系统

### 技术优化
- [ ] 代码模块化
- [ ] 单元测试
- [ ] 性能优化
- [ ] 错误日志系统

---

## 📚 相关资源

### BLUPF90官方资源
- 官网: http://nce.ads.uga.edu/wiki/doku.php
- 手册: BLUPF90 User Manual
- 论坛: BLUPF90 Users Group

### R Shiny资源
- 官网: https://shiny.rstudio.com/
- 教程: https://shiny.rstudio.com/tutorial/
- Gallery: https://shiny.rstudio.com/gallery/

### 相关包文档
- sortable: https://rstudio.github.io/sortable/
- shinyjqui: https://yang-tang.github.io/shinyjqui/

---

## 👥 项目贡献

### 开发者信息
- GitHub: https://github.com/Thymine2001/easyblup
- 许可证: MIT License

### 如何贡献
1. Fork项目
2. 创建特性分支
3. 提交更改
4. 推送到分支
5. 创建Pull Request

---

## 📞 支持与反馈

如有问题或建议，请：
1. 提交GitHub Issue
2. 查看USAGE.md获取详细使用说明
3. 参考在线演示版本

---

**最后更新**: 2025-10-10
**版本**: 0.1.0
**状态**: ✅ 生产就绪
