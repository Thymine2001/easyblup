# easyblup 使用说明

## 快速开始

### 1. 安装依赖包

在 R 控制台中运行：

```r
# 安装必需的包
install.packages(c("shiny", "sortable"))

# 或者使用提供的安装脚本
source("run_app.R")
```

### 2. 启动应用

```r
# 方法1：直接运行
shiny::runApp()

# 方法2：使用提供的脚本
source("run_app.R")
```

## 详细使用步骤

### 步骤 1：上传数据文件

1. **上传表型数据**：
   - 在左侧面板点击 "1. Upload Phenotypic Data (.csv)" 按钮
   - 选择包含您的表型数据的 CSV 文件
   - 文件应包含动物ID、性状数据、固定效应等列
   - **文件大小限制：最大 10GB**

2. **上传基因型数据（可选）**：
   - 在左侧面板点击 "2. Upload Genotype Data (Optional)" 按钮
   - 选择 PLINK 格式的 PED 和 MAP 文件
   - **必须同时上传 PED 和 MAP 文件**
   - **文件大小限制：总计最大 10GB**
   - PED 文件：包含基因型数据
   - MAP 文件：包含标记信息

### 步骤 2：查看可用变量

上传数据后，您将在主面板顶部看到：
- 所有列名以蓝色"药丸"状按钮形式显示
- 每个按钮代表数据中的一个变量
- 按钮具有悬停效果和拖拽提示

### 步骤 3：定义模型

通过拖放操作将变量分配到模型的各个组件：

#### 3.1 性状 (Traits - y) 🧬
- 将您要分析的性状变量拖入橙色 "Traits (y)" 区域
- 可以拖入多个性状进行多性状分析
- 例如：milk_yield, fat_content, protein_content

#### 3.2 固定效应 (Fixed Effects - b) 📊
- 将固定效应变量拖入红色 "Fixed Effects (b)" 区域
- 例如：herd, sex, age, parity

#### 3.3 动物ID (Animal ID - a) 🐄
- 将动物ID变量拖入绿色 "Animal ID (a)" 区域
- 这是进行动物模型分析必需的
- 例如：animal_id

#### 3.4 其他随机效应 (Other Random Effects - r) 🎲
- 将其他随机效应变量拖入蓝色 "Random Effects (r)" 区域
- 例如：dam_id, sire_id 等

### 步骤 4：查看参数文件预览

在页面底部，您将看到实时生成的 renumf90 参数文件预览，包括：

- **DATAFILE**: 数据文件名
- **TRAITS**: 性状列号
- **FIELDS_PASSED_TO_OUTPUT**: 输出字段
- **EFFECTS**: 效应列号
- **RANDOM**: 随机效应定义
- **OPTION**: 各种选项设置

## 示例数据格式

### CSV 文件格式要求

您的表型数据文件应包含以下列：

```csv
animal_id,herd,sex,age,weight,milk_yield,fat_content,protein_content
1,1,M,24,450,6500,3.8,3.2
2,1,F,36,520,7200,4.1,3.4
3,2,M,18,380,0,0,0
...
```

### PLINK 基因型文件格式

**PED 文件格式**：
```
1 1 0 0 1 0 1 2 2 1 2 1 1 2 1 2 2 1 2 1 1 2
2 2 0 0 1 0 1 2 2 1 2 1 1 2 1 2 2 1 2 1 1 2
...
```

**MAP 文件格式**：
```
1 rs12345 0 12345
1 rs67890 0 67890
...
```

### 列名建议

- **动物ID**: animal_id, id, animal
- **性状**: milk_yield, weight, height, etc.
- **固定效应**: herd, sex, age, year, season, etc.
- **随机效应**: permanent_environment, maternal, etc.

### 文件大小限制

- **表型数据**: 最大 10GB
- **基因型数据**: PED + MAP 文件总计最大 10GB

## 生成的参数文件说明

### 基本结构

**仅表型数据**：
```
DATAFILE
your_data.csv

TRAITS
3 4 5

FIELDS_PASSED_TO_OUTPUT
3 4 5

WEIGHT(S)
# 权重列（如需要）

EFFECTS
1 2 6
7
8

RANDOM
animal
permanent_environment

OPTION solv_method FSPAK
OPTION missing -999
OPTION maxrounds 500
OPTION conv_crit 1e-6
```

**包含基因型数据**：
```
DATAFILE
your_data.csv

PEDFILE
your_data.ped

MAPFILE
your_data.map

TRAITS
3 4 5

FIELDS_PASSED_TO_OUTPUT
3 4 5

WEIGHT(S)
# 权重列（如需要）

EFFECTS
1 2 6
7
8

RANDOM
animal
permanent_environment

# Genomic analysis options
OPTION use_yams
OPTION solv_method FSPAK
OPTION missing -999
OPTION maxrounds 500
OPTION conv_crit 1e-6
```

### 参数说明

- **DATAFILE**: 表型数据文件名
- **PEDFILE**: 基因型数据文件名（仅当上传基因型数据时）
- **MAPFILE**: 标记信息文件名（仅当上传基因型数据时）
- **TRAITS**: 性状列号，对应您拖入性状区域的变量
- **EFFECTS**: 效应列号，按顺序列出固定效应、动物ID、其他随机效应
- **RANDOM**: 随机效应类型，通常包括 "animal" 和其他随机效应
- **OPTION**: 求解选项，包括求解方法、缺失值处理等
- **use_yams**: 基因组分析选项（仅当上传基因型数据时）

## 故障排除

### 常见问题

1. **应用无法启动**
   - 确保已安装所有必需的包
   - 检查 R 版本是否 >= 3.6.0

2. **拖放功能不工作**
   - 确保已安装 sortable 包
   - 刷新浏览器页面

3. **CSV 文件读取错误**
   - 检查文件格式是否正确
   - 确保文件编码为 UTF-8
   - 检查列名是否包含特殊字符
   - 检查文件大小是否超过 10GB 限制

4. **基因型文件错误**
   - 确保同时上传了 PED 和 MAP 文件
   - 检查文件格式是否为 PLINK 标准格式
   - 检查文件大小是否超过 10GB 限制
   - 确保 PED 和 MAP 文件中的标记信息匹配

5. **参数文件生成错误**
   - 确保至少拖入了一个性状变量
   - 确保拖入了动物ID变量

### 技术支持

如果遇到问题，请检查：
1. R 和包版本
2. 数据文件格式
3. 浏览器控制台错误信息

## 高级功能

### 多性状分析

- 拖入多个性状到 "Traits" 区域
- 系统会自动生成多性状分析的参数

### 复杂模型

- 可以添加多个随机效应
- 支持各种固定效应组合

### 参数自定义

- 可以手动编辑生成的参数文件
- 支持各种 BLUPF90 选项
