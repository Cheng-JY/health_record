# HealthRecord · 个人健康记录

HealthRecord 是一款本地优先的个人健康管理应用。你可以在同一个地方整理不同医院的检查结果、查看长期指标变化，并记录就诊、用药和日常症状。当前版本以 Flutter Web 为运行目标，界面为简体中文。

## 功能

| 模块 | 支持的操作 |
| --- | --- |
| 检查结果 | 手动录入或批量导入 CSV。导入前可预览、检查错误并选择医院，导入时会跳过重复记录。 |
| 指标趋势 | 在同一页面查看手动录入与导入的结果，按医院筛选。不同单位分别绘图，保留原始结果与参考范围。 |
| 医院管理 | 管理医院信息，批量为检查记录分配医院，合并重复的医院条目。 |
| 就诊记录 | 记录就诊信息，关联已有检查结果，保存和下载就诊 PDF 附件。 |
| 用药与库存 | 查看今日用药计划和历史方案，按药品规格与批次登记库存和库存变动。根据手动确认的每日实际消耗量估算库存可用天数。 |
| 症状日记 | 记录症状、发生时间、严重程度、备注和照片。 |
| 备份与恢复 | 导出完整 JSON 备份。导入时先预览，确认后替换当前浏览器中的记录。 |

## 本地运行

准备 Flutter SDK、Git 和 Chrome。当前仓库的 `pubspec.lock` 要求 Flutter 3.47.0 或更高版本，Dart 版本范围为 3.13.5 至 4.0.0 以下。

```bash
git clone https://github.com/Cheng-JY/health_record.git
cd health_record
flutter pub get
flutter run -d chrome --web-port 8080
```

用下面的命令构建 Web 文件。

```bash
flutter build web
```

构建产物位于 `build/web/`。仓库的 [web/](web/) 目录包含 SQLite WebAssembly 和 Drift Worker。

## 导入检查结果

在「检查结果」中打开 CSV 导入，选择 UTF-8 编码、逗号分隔的文件，预览后选择所属医院并确认。保留下面的表头，每行填写一项检查结果。其中，采样日期、指标名称和结果必须填写。下面的数据仅用于演示格式。

```csv
report_id,sample_date,report_date,indicator_code,indicator_name_cn,value,unit,reference_range,category
DEMO-001,2026-01-15,2026-01-15,WBC,白细胞计数,6.2,10^9/L,4.0-10.0,血常规
```

## 数据存储与同步

- **本地存储**。默认将记录写入当前浏览器的数据库。开发时固定访问地址和端口，便于继续使用同一份数据。清除站点数据前可以先导出 JSON 备份。
- **实验性同步**。可在 Mac 上运行随仓库提供的 [Python 同步服务](tools/healthrecord_sync/healthrecord_sync_server.py)，通过 Tailscale Serve 的私有 HTTPS 地址供 iPhone 浏览器访问。同步以完整数据库快照为单位。双方各自有改动时，自动同步会暂停。
- **备份内容**。JSON 备份可包含检验结果、用药、症状照片和就诊 PDF。备份文件及同步服务保存的快照均为明文，请妥善保存。

## 技术栈

- Flutter 与 Dart 构建 Web 界面
- Riverpod 管理应用状态
- Drift、SQLite 与 WebAssembly 提供本地存储
- fl_chart 绘制检验指标趋势
- Python 标准库提供可选的私有同步服务
