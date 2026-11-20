// HEALTHRECORD_UI_I18N_V2
// Display-only translations. No medical records or imported data are modified.
import 'package:flutter/material.dart';

class UiI18n {
  static const Map<String, Map<String, String>> translations = {
    "CSV 导入": {"en": "Import CSV", "de": "CSV importieren"},
    "CSV 导入记录": {
      "en": "Imported CSV Records",
      "de": "Importierte CSV-Einträge",
    },
    "CSV 检查报告导入": {
      "en": "Import CSV Lab Report",
      "de": "CSV-Laborbericht importieren",
    },
    "CSV 解析错误": {"en": "CSV Parsing Error", "de": "CSV-Analysefehler"},
    "Mac ↔ iPhone 同步": {
      "en": "Mac ↔ iPhone Sync",
      "de": "Mac ↔ iPhone Synchronisierung",
    },
    "PDF 名称与备注": {"en": "PDF Name and Notes", "de": "PDF-Name und Notizen"},
    "PDF 文件与备注": {"en": "PDF File and Notes", "de": "PDF-Datei und Notizen"},
    "上传 PDF": {"en": "Upload PDF", "de": "PDF hochladen"},
    "上传医疗文件": {
      "en": "Upload Medical File",
      "de": "Medizinische Datei hochladen",
    },
    "下载 PDF": {"en": "Download PDF", "de": "PDF herunterladen"},
    "不包含 CSV 中的其他指标": {
      "en": "Other CSV indicators excluded",
      "de": "Andere CSV-Messwerte ausgeschlossen",
    },
    "不可分割": {"en": "Cannot be split", "de": "Nicht teilbar"},
    "不同规格分别记账。预计天数只统计明确设置了每日实际消耗量的批次。": {
      "en": "Strengths are tracked separately. Estimated days include only batches with confirmed daily usage.",
      "de": "Stärken werden getrennt erfasst. Die Resttage umfassen nur Chargen mit bestätigtem Tagesverbrauch.",
    },
    "不同记录的参考范围不一致：图表不显示统一参考线，具体范围见各条记录。": {
      "en": "Reference ranges differ; no shared reference line is shown.",
      "de": "Referenzbereiche unterscheiden sich; keine gemeinsame Referenzlinie.",
    },
    "不确定": {"en": "Not sure", "de": "Nicht sicher"},
    "丢弃 / 过期": {"en": "Discarded / Expired", "de": "Entsorgt / Abgelaufen"},
    "仅列出尚未指定医院、且未删除的 CSV 记录。手动录入记录暂不支持医院关联。": {
      "en": "Shows only active CSV records without a hospital; manual records cannot yet be linked.",
      "de": "Nur aktive CSV-Einträge ohne Krankenhaus; manuelle Einträge können noch nicht zugeordnet werden.",
    },
    "今天没有生效的服药方案": {
      "en": "No active regimen today",
      "de": "Heute kein aktiver Einnahmeplan",
    },
    "今天没有生效的服药方案。": {
      "en": "No active regimen today.",
      "de": "Heute kein aktiver Einnahmeplan.",
    },
    "今天的服药方案": {"en": "Today's Regimen", "de": "Heutiger Einnahmeplan"},
    "今日用药计划": {
      "en": "Today's Medication Plan",
      "de": "Heutiger Medikationsplan",
    },
    "使用 / 盘点": {"en": "Use / Stocktake", "de": "Verbrauch / Bestandsaufnahme"},
    "保存": {"en": "Save", "de": "Speichern"},
    "保存修改": {"en": "Save Changes", "de": "Änderungen speichern"},
    "保存库存": {"en": "Save Stock", "de": "Bestand speichern"},
    "保存新方案": {"en": "Save New Regimen", "de": "Neuen Einnahmeplan speichern"},
    "修改 CSV 检查结果": {
      "en": "Edit CSV Lab Result",
      "de": "CSV-Laborwert bearbeiten",
    },
    "健康数据概览": {
      "en": "Health Data Overview",
      "de": "Übersicht der Gesundheitsdaten",
    },
    "健康记录与日常管理": {
      "en": "Health Records and Daily Management",
      "de": "Gesundheitsdaten und Alltag",
    },
    "允许分割需以具体药品说明书或药师确认为准。": {
      "en":
          "Only split when confirmed by the product information or pharmacist.",
      "de": "Nur teilen, wenn Packungsbeilage oder Apotheke dies bestätigen.",
    },
    "允许分片及最小分片份数必须经药品说明书或药师确认。": {
      "en": "Splitting and minimum portions must be confirmed by product information or a pharmacist.",
      "de": "Teilbarkeit und kleinste Teilmenge müssen anhand der Packungsbeilage oder in der Apotheke bestätigt werden.",
    },
    "全选": {"en": "Select All", "de": "Alle auswählen"},
    "全选当前结果": {
      "en": "Select Current Results",
      "de": "Aktuelle Werte auswählen",
    },
    "全部医院": {"en": "All Hospitals", "de": "Alle Krankenhäuser"},
    "关联检查结果": {"en": "Link Lab Results", "de": "Laborwerte verknüpfen"},
    "分配所选记录": {
      "en": "Assign Selected Records",
      "de": "Ausgewählte Einträge zuweisen",
    },
    "删除": {"en": "Delete", "de": "Löschen"},
    "删除 PDF 附件？": {"en": "Delete PDF Attachment?", "de": "PDF-Anhang löschen?"},
    "删除医院": {"en": "Delete Hospital", "de": "Krankenhaus löschen"},
    "删除历史": {"en": "Delete History", "de": "Verlauf löschen"},
    "删除导入记录？": {
      "en": "Delete Imported Result?",
      "de": "Importierten Wert löschen?",
    },
    "删除就诊记录": {"en": "Delete Visit Record", "de": "Behandlungseintrag löschen"},
    "删除报告分组": {"en": "Delete Report Group", "de": "Berichtsgruppe löschen"},
    "删除症状记录？": {
      "en": "Delete Symptom Record?",
      "de": "Symptomeintrag löschen?",
    },
    "删除记录？": {"en": "Delete Record?", "de": "Eintrag löschen?"},
    "删除这条用药历史？": {
      "en": "Delete this medication history entry?",
      "de": "Diesen Eintrag im Einnahmeverlauf löschen?",
    },
    "删除附件": {"en": "Delete Attachment", "de": "Anhang löschen"},
    "剩余数量请通过「使用 / 盘点」修改；购入数量和原始流水不会被改写。": {
      "en": "Change remaining stock via Use / Stocktake; purchase records remain unchanged.",
      "de": "Restbestand über Verbrauch / Bestandsaufnahme ändern; Kaufbelege bleiben unverändert.",
    },
    "医院": {"en": "Hospitals", "de": "Krankenhäuser"},
    "医院 UUID 固定不变。编辑医院名称不会影响已有检查记录的关联。": {
      "en": "Hospital IDs remain stable; renaming does not change linked records.",
      "de": "Krankenhaus-IDs bleiben stabil; Umbenennen ändert keine Verknüpfungen.",
    },
    "医院与就诊管理": {
      "en": "Hospitals and Visits",
      "de": "Krankenhäuser und Behandlungen",
    },
    "医院关联工具": {
      "en": "Hospital Linking Tools",
      "de": "Werkzeuge zur Krankenhauszuordnung",
    },
    "医院管理": {"en": "Hospital Management", "de": "Krankenhausverwaltung"},
    "单位": {"en": "Unit", "de": "Einheit"},
    "历史记录": {"en": "History", "de": "Verlauf"},
    "历史记录已删除；请检查剩余方案的日期是否连续": {
      "en": "History entry deleted; check date continuity.",
      "de": "Verlaufseintrag gelöscht; zeitliche Abfolge prüfen.",
    },
    "参考范围": {"en": "Reference Range", "de": "Referenzbereich"},
    "取消": {"en": "Cancel", "de": "Abbrechen"},
    "取消全选": {"en": "Deselect All", "de": "Auswahl aufheben"},
    "只显示同医院的 CSV 结果及尚未关联的手动记录。": {
      "en": "Shows CSV results from this hospital and unlinked manual records.",
      "de": "Zeigt CSV-Werte dieses Krankenhauses und unverknüpfte manuelle Werte.",
    },
    "可以分割": {"en": "Can be split", "de": "Teilbar"},
    "可调整这一阶段的起止日期。结束日期留空时会自动衔接下一阶段；已有前一段持续中方案也会自动截止。": {
      "en": "You can change the start and end dates. An open-ended stage is linked to the next; a prior ongoing stage is closed.",
      "de": "Beginn und Ende können geändert werden. Offene Phasen werden an die nächste angeschlossen, vorherige laufende Phasen abgeschlossen.",
    },
    "可选择过去或未来的任意日期；前一段持续中方案会自动截止到新方案开始前一天。其他日期重叠会阻止保存。": {
      "en": "Choose past or future dates; the previous ongoing regimen ends before the new one. Overlapping dates are rejected.",
      "de": "Vergangene oder künftige Daten wählen; ein laufender Plan endet vor dem neuen. Überschneidungen sind nicht erlaubt.",
    },
    "合并医院": {"en": "Merge Hospitals", "de": "Krankenhäuser zusammenführen"},
    "合并医院（不可直接撤销）": {
      "en": "Merge Hospitals (cannot be undone)",
      "de": "Krankenhäuser zusammenführen (nicht direkt rückgängig)",
    },
    "合并查看手动录入和 CSV 数据。不同单位分别显示；原始结果不会被修改。": {
      "en": "Combined manual and CSV results. Units are displayed separately; originals remain unchanged.",
      "de": "Manuelle und CSV-Werte zusammen. Einheiten getrennt; Originale unverändert.",
    },
    "合并重复医院": {
      "en": "Merge Duplicate Hospitals",
      "de": "Doppelte Krankenhäuser zusammenführen",
    },
    "同步节点需要 Mac 持续开机并运行。仅通过 Tailscale Serve 私有 HTTPS 地址访问，不要使用公网 Funnel。": {
      "en": "Mac must stay on to host sync. Use private Tailscale HTTPS, not public Funnel.",
      "de": "Mac muss für die Synchronisierung laufen. Privates Tailscale-HTTPS verwenden, kein öffentliches Funnel.",
    },
    "备份将包括检查结果、医院、就诊、报告关联及完整用药历史。": {
      "en": "Backup includes lab results, hospitals, visits, report links and medication history.",
      "de": "Backup umfasst Laborwerte, Krankenhäuser, Behandlungen, Berichtslinks und Medikamentenverlauf.",
    },
    "实验性自动同步（页面打开期间每45秒检查）。只有单端有变化时自动传输；两端都改动则暂停，绝不悄悄覆盖。": {
      "en": "Experimental sync checks every 45 seconds while open. Conflicts pause transfers.",
      "de": "Experimentelle Synchronisierung prüft alle 45 Sekunden bei geöffnetem Fenster. Konflikte stoppen die Übertragung.",
    },
    "导入备份": {"en": "Import Backup", "de": "Backup importieren"},
    "导入备份并替换本地数据": {
      "en": "Restore Backup and Replace Local Data",
      "de": "Backup wiederherstellen und lokale Daten ersetzen",
    },
    "导入预览（前 30 行）": {
      "en": "Import Preview (first 30 rows)",
      "de": "Importvorschau (erste 30 Zeilen)",
    },
    "导出完整 JSON 备份": {
      "en": "Export Full JSON Backup",
      "de": "Vollständiges JSON-Backup exportieren",
    },
    "导出的 JSON 带有 SHA-256 数据校验和稳定设备标识；它不会自动上传或同步到手机。": {
      "en": "Exported JSON contains a SHA-256 checksum and device ID; it is not uploaded automatically.",
      "de": "Das JSON enthält eine SHA-256-Prüfsumme und Geräte-ID; es wird nicht automatisch hochgeladen.",
    },
    "尚无记录，点击右下角录入": {
      "en": "No records yet. Use Add below.",
      "de": "Noch keine Einträge. Unten hinzufügen.",
    },
    "就诊 PDF 附件": {
      "en": "Visit PDF Attachments",
      "de": "PDF-Anhänge zur Behandlung",
    },
    "就诊管理": {"en": "Visit Management", "de": "Behandlungsverwaltung"},
    "已保存检查结果": {"en": "Saved Lab Results", "de": "Gespeicherte Laborwerte"},
    "已服用 / 使用": {"en": "Taken / Used", "de": "Eingenommen / Verwendet"},
    "库存变动记录": {"en": "Inventory History", "de": "Bestandsverlauf"},
    "库存天数根据每批确认的实际每日消耗片数估算；不会自动按 mg 换算，也不会自动扣减服用量。": {
      "en": "Days remaining use confirmed daily tablet counts per batch; no automatic mg conversion or deduction.",
      "de": "Resttage basieren auf bestätigtem Tablettenverbrauch je Charge; keine automatische mg-Umrechnung oder Abbuchung.",
    },
    "录入检查": {"en": "Add Lab Result", "de": "Laborwert erfassen"},
    "恢复成功": {"en": "Restore Complete", "de": "Wiederherstellung abgeschlossen"},
    "我的健康": {"en": "My Health", "de": "Meine Gesundheit"},
    "我的症状日记": {"en": "My Symptom Diary", "de": "Mein Symptomtagebuch"},
    "所有医院 / 全部来源": {
      "en": "All Hospitals / Sources",
      "de": "Alle Krankenhäuser / Quellen",
    },
    "手动录入": {"en": "Manual Entry", "de": "Manuelle Eingabe"},
    "手动录入 + CSV 导入": {
      "en": "Manual Entry + CSV Import",
      "de": "Manuelle Eingabe + CSV-Import",
    },
    "手动录入记录": {"en": "Manual Records", "de": "Manuelle Einträge"},
    "批量分配 / 合并医院": {
      "en": "Bulk Assign / Merge Hospitals",
      "de": "Krankenhäuser zuweisen / zusammenführen",
    },
    "批量分配历史记录": {
      "en": "Assign Historical Records",
      "de": "Historische Einträge zuweisen",
    },
    "指标代码": {"en": "Indicator Code", "de": "Messwertcode"},
    "指标名称": {"en": "Indicator Name", "de": "Messwertname"},
    "按指标代码合并显示，保留每条记录的原始来源；未自动进行单位换算。": {
      "en": "Results are grouped by indicator code; sources are preserved. Units are not converted automatically.",
      "de": "Werte sind nach Code gruppiert, Quellen bleiben erhalten. Einheiten werden nicht automatisch umgerechnet.",
    },
    "提示：界限值的绘图替代数值不是实际检测结果；不同医院或检测方法的参考范围可能不同。": {
      "en": "Note: substitutions for limit values are not measured results; ranges may vary.",
      "de": "Hinweis: Ersatzwerte für Grenzwerte sind keine Messwerte; Bereiche können variieren.",
    },
    "数据保存在本地 SQLite 数据库中。": {
      "en": "Data is stored in local SQLite.",
      "de": "Daten werden in lokaler SQLite gespeichert.",
    },
    "数据已写入本地浏览器数据库。点击确定后重新载入页面。": {
      "en": "Data restored to the local browser database. Reload the page to continue.",
      "de": "Daten in der lokalen Browserdatenbank wiederhergestellt. Seite neu laden.",
    },
    "整理检查指标": {
      "en": "Organize Lab Indicators",
      "de": "Laborwerte organisieren",
    },
    "文件仅下载到你的设备，不上传到服务器。JSON 是明文格式，请妥善保管。": {
      "en": "The file stays on your device. JSON is unencrypted; store it safely.",
      "de": "Die Datei bleibt auf Ihrem Gerät. JSON ist unverschlüsselt; bitte sicher aufbewahren.",
    },
    "新增": {"en": "Add", "de": "Hinzufügen"},
    "新增历史或未来服药方案": {
      "en": "Add Past or Future Regimen",
      "de": "Vergangenen oder künftigen Einnahmeplan hinzufügen",
    },
    "新增就诊": {"en": "Add Visit", "de": "Behandlung hinzufügen"},
    "新增库存": {"en": "Add Stock", "de": "Bestand hinzufügen"},
    "新增检查报告": {"en": "Add Lab Report", "de": "Laborbericht hinzufügen"},
    "新增症状": {"en": "Add Symptom", "de": "Symptom hinzufügen"},
    "新建报告分组，再从已有检查数据中选择记录关联。日期不要求与就诊日期完全一致。": {
      "en": "Create a report group and link existing lab results; dates need not match exactly.",
      "de": "Berichtsgruppe erstellen und vorhandene Laborwerte verknüpfen; Datum muss nicht exakt stimmen.",
    },
    "日常记录保存在当前浏览器的本地 SQLite 数据库。清除网站数据可能导致丢失。": {
      "en": "Records are stored in this browser's local SQLite database. Clearing site data may delete them.",
      "de": "Einträge liegen in der lokalen SQLite-Datenbank dieses Browsers. Löschen von Websitedaten kann sie entfernen.",
    },
    "显示已停用药物": {
      "en": "Show Discontinued Medications",
      "de": "Abgesetzte Medikamente anzeigen",
    },
    "暂无指标": {"en": "No Indicators", "de": "Keine Laborwerte"},
    "暂无检查结果，请先手动录入或导入 CSV。": {
      "en": "No lab results yet. Enter one manually or import CSV.",
      "de": "Noch keine Laborwerte. Manuell eingeben oder CSV importieren.",
    },
    "暂无符合条件的就诊记录": {
      "en": "No matching visits",
      "de": "Keine passenden Behandlungen",
    },
    "暂无药物记录，点击右下角添加": {
      "en": "No medications yet. Use Add to create one.",
      "de": "Noch keine Medikamente. Über „Hinzufügen“ anlegen.",
    },
    "暂未分类": {"en": "Uncategorized", "de": "Nicht kategorisiert"},
    "未删除的 CSV 检查结果": {
      "en": "Active CSV Lab Results",
      "de": "Aktive CSV-Laborwerte",
    },
    "未删除的手动检查结果": {
      "en": "Active Manual Lab Results",
      "de": "Aktive manuelle Laborwerte",
    },
    "未填写结束日期时，如果已有下一阶段，将自动截止到下一阶段开始前一天。": {
      "en": "When no end date is set, the preceding stage ends before the next stage.",
      "de": "Ohne Enddatum endet die Phase vor der nächsten Phase.",
    },
    "未指定医院（含手动记录）": {
      "en": "Unassigned Hospital (incl. manual)",
      "de": "Ohne Krankenhaus (inkl. manuell)",
    },
    "本地备份与恢复": {
      "en": "Local Backup and Restore",
      "de": "Lokales Backup und Wiederherstellung",
    },
    "本地数据安全状态": {"en": "Local Data Safety", "de": "Sicherheit lokaler Daten"},
    "本次就诊尚无 PDF 附件。": {
      "en": "No PDF attachments for this visit.",
      "de": "Keine PDF-Anhänge für diese Behandlung.",
    },
    "本次就诊尚未关联检查报告": {
      "en": "No linked lab reports for this visit",
      "de": "Keine verknüpften Laborberichte",
    },
    "本次检查报告": {
      "en": "Lab Reports for This Visit",
      "de": "Laborberichte dieses Besuchs",
    },
    "本次检查报告与结果": {
      "en": "Visit Reports and Results",
      "de": "Besuchsberichte und Laborwerte",
    },
    "查看": {"en": "View", "de": "Ansehen"},
    "查看剩余天数、管理包装与购入批次": {
      "en": "View days remaining, packs and purchase batches",
      "de": "Resttage, Packungen und Bestandschargen verwalten",
    },
    "查看当前服药计划与剂量调整历史": {
      "en": "View current regimen and dosage history",
      "de": "Aktuellen Einnahmeplan und Dosisverlauf ansehen",
    },
    "根据医院、采样时间、检查指标、结果和单位": {
      "en": "By hospital, sample time, indicator, result and unit",
      "de": "Nach Krankenhaus, Probenzeit, Messwert, Ergebnis und Einheit",
    },
    "检查医院": {"en": "Testing Hospital", "de": "Untersuchendes Krankenhaus"},
    "检查历史记录": {"en": "Lab Result History", "de": "Laborwertverlauf"},
    "检查并清理重复记录": {
      "en": "Check and Clean Duplicate Records",
      "de": "Duplikate prüfen und bereinigen",
    },
    "检查指标趋势": {"en": "Lab Indicator Trends", "de": "Laborwerttrends"},
    "检查结果": {"en": "Lab Results", "de": "Laborergebnisse"},
    "检查结果趋势图": {"en": "Lab Result Trends", "de": "Laborwertverlauf"},
    "此版本是完整快照同步，不是逐条合并；跨设备同时编辑会暂停并等待人工处理。备份在 Mac 磁盘上为明文，请启用 FileVault。": {
      "en": "Full snapshots, not per-record merges. Concurrent edits are paused. Mac backups are unencrypted; enable FileVault.",
      "de": "Vollständige Snapshots statt Einzelabgleich. Gleichzeitige Änderungen werden pausiert. Mac-Backups sind unverschlüsselt; FileVault aktivieren.",
    },
    "每次剂量与服用次数变更历史": {
      "en": "Dose and Frequency History",
      "de": "Verlauf der Dosis und Einnahmehäufigkeit",
    },
    "没有库存批次，请在库存首页点击「新增库存」。": {
      "en": "No stock batches yet. Choose Add Stock on the inventory page.",
      "de": "Noch keine Bestandsposten. Auf der Bestandsseite „Bestand hinzufügen“ wählen.",
    },
    "没有未指定医院的有效 CSV 记录": {
      "en": "No CSV entries without a hospital",
      "de": "Keine CSV-Einträge ohne Krankenhaus",
    },
    "没有符合条件的医院。": {
      "en": "No matching hospitals.",
      "de": "Keine passenden Krankenhäuser.",
    },
    "添加医院": {"en": "Add Hospital", "de": "Krankenhaus hinzufügen"},
    "添加新医院": {"en": "Add New Hospital", "de": "Neues Krankenhaus hinzufügen"},
    "添加照片": {"en": "Add Photo", "de": "Foto hinzufügen"},
    "添加药物": {"en": "Add Medication", "de": "Medikament hinzufügen"},
    "添加药物和初始服药方案": {
      "en": "Add Medication and Initial Regimen",
      "de": "Medikament und ersten Einnahmeplan hinzufügen",
    },
    "清理重复检查记录": {
      "en": "Clean Duplicate Lab Results",
      "de": "Doppelte Laborwerte bereinigen",
    },
    "清空选择": {"en": "Clear Selection", "de": "Auswahl aufheben"},
    "清除结束日期": {"en": "Clear End Date", "de": "Enddatum löschen"},
    "清除结束日期（持续中）": {
      "en": "Clear End Date (ongoing)",
      "de": "Enddatum löschen (laufend)",
    },
    "照片仅保存于本地数据库，最多 3 张，每张不超过 3 MB。": {
      "en": "Photos are stored locally, up to three photos of 3 MB each.",
      "de": "Fotos werden lokal gespeichert, bis zu drei mit je 3 MB.",
    },
    "片剂": {"en": "Tablet", "de": "Tablette"},
    "用药管理": {"en": "Medication Management", "de": "Medikamentenverwaltung"},
    "用药记录暂时无法读取，请进入用药管理查看。": {
      "en": "Medication records unavailable. Check Medication Management.",
      "de":
          "Medikation derzeit nicht verfügbar. Medikamentenverwaltung öffnen.",
    },
    "界限值的绘图规则可在底部「设置」页面统一调整；原始检测值不会改变。": {
      "en": "Chart handling of limit values is configurable in Settings; raw values remain unchanged.",
      "de": "Grenzwertdarstellung in Einstellungen anpassbar; Rohwerte bleiben gleich.",
    },
    "症状记录": {"en": "Symptom Records", "de": "Symptomaufzeichnungen"},
    "盘点：设为实际剩余": {
      "en": "Stocktake: set remaining quantity",
      "de": "Bestandsaufnahme: Restmenge festlegen",
    },
    "目前只有一个可绘制数据点。": {
      "en": "Only one plottable data point.",
      "de": "Nur ein darstellbarer Datenpunkt.",
    },
    "目前还没有导入检查记录。": {
      "en": "No imported lab results yet.",
      "de": "Noch keine importierten Laborwerte.",
    },
    "目标医院 UUID 将保留；来源医院将删除。操作前请先备份数据。": {
      "en": "The target hospital ID is retained and the source deleted. Back up first.",
      "de": "Die Ziel-Krankenhaus-ID bleibt erhalten, die Quelle wird gelöscht. Vorher sichern.",
    },
    "确定": {"en": "OK", "de": "OK"},
    "确认": {"en": "Confirm", "de": "Bestätigen"},
    "确认停药记录": {
      "en": "Confirm Discontinuation Record",
      "de": "Absetzen bestätigen",
    },
    "确认删除": {"en": "Confirm Deletion", "de": "Löschen bestätigen"},
    "确认合并": {"en": "Confirm Merge", "de": "Zusammenführung bestätigen"},
    "确认导入": {"en": "Confirm Import", "de": "Import bestätigen"},
    "确认恢复备份？": {"en": "Restore Backup?", "de": "Backup wiederherstellen?"},
    "确认批量分配医院": {
      "en": "Confirm Hospital Assignment",
      "de": "Krankenhauszuordnung bestätigen",
    },
    "确认替换并恢复": {
      "en": "Replace and Restore",
      "de": "Ersetzen und wiederherstellen",
    },
    "确认清理": {"en": "Confirm Cleanup", "de": "Bereinigung bestätigen"},
    "结束日期不能早于开始日期": {
      "en": "End date must not precede start date",
      "de": "Enddatum darf nicht vor dem Beginn liegen",
    },
    "绿色区域：该检查报告的参考范围": {
      "en": "Green area: reference range for this report",
      "de": "Grüner Bereich: Referenzbereich dieses Berichts",
    },
    "编辑": {"en": "Edit", "de": "Bearbeiten"},
    "编辑历史": {"en": "Edit History", "de": "Verlauf bearbeiten"},
    "编辑名称 / 备注": {"en": "Edit Name / Notes", "de": "Name / Notizen bearbeiten"},
    "编辑库存批次": {"en": "Edit Inventory Batch", "de": "Bestandsposten bearbeiten"},
    "编辑用药历史": {
      "en": "Edit Medication History",
      "de": "Medikamentenverlauf bearbeiten",
    },
    "编辑药物资料": {
      "en": "Edit Medication Details",
      "de": "Medikamentendaten bearbeiten",
    },
    "编辑资料": {"en": "Edit Details", "de": "Daten bearbeiten"},
    "胶囊": {"en": "Capsule", "de": "Kapsel"},
    "胶囊不提供分片选项。": {
      "en": "No splitting option for capsules.",
      "de": "Keine Teilungsoption für Kapseln.",
    },
    "胶囊默认不可拆分。": {
      "en": "Capsules cannot normally be split.",
      "de": "Kapseln sind in der Regel nicht teilbar.",
    },
    "药剂能否分割？*": {
      "en": "Can this medicine be split? *",
      "de": "Ist dieses Medikament teilbar? *",
    },
    "药品库存": {"en": "Medication Inventory", "de": "Medikamentenvorrat"},
    "药品库存管理": {
      "en": "Medication Inventory Management",
      "de": "Medikamentenvorrat verwalten",
    },
    "药片是否可分割？": {
      "en": "Can the tablet be split?",
      "de": "Ist die Tablette teilbar?",
    },
    "药物资料": {"en": "Medication Details", "de": "Medikamentendaten"},
    "警告：此操作会完全替换当前浏览器的 HealthRecord 数据。": {
      "en": "Warning: This replaces all current local HealthRecord data.",
      "de": "Warnung: Dadurch werden alle lokalen HealthRecord-Daten ersetzt.",
    },
    "记录停药": {"en": "Record Discontinuation", "de": "Absetzen dokumentieren"},
    "记录新症状": {"en": "Record New Symptom", "de": "Neues Symptom erfassen"},
    "记录症状、发生时间、严重程度与备注": {
      "en": "Record symptoms, time, severity and notes",
      "de": "Symptome, Zeitpunkt, Schweregrad und Notizen erfassen",
    },
    "设置": {"en": "Settings", "de": "Einstellungen"},
    "该医院暂无有效的 CSV 检查结果": {
      "en": "No active CSV lab results for this hospital",
      "de": "Keine aktiven CSV-Laborwerte für dieses Krankenhaus",
    },
    "该指标在当前单位下没有可绘图的数值结果。": {
      "en": "No plottable numeric values for this unit.",
      "de": "Keine darstellbaren Werte in dieser Einheit.",
    },
    "该指标当前没有可显示的趋势记录。": {
      "en": "No trend records for this indicator.",
      "de": "Keine Verlaufswerte für diesen Messwert.",
    },
    "该操作将隐藏这条记录。": {
      "en": "This hides this record.",
      "de": "Dadurch wird dieser Eintrag ausgeblendet.",
    },
    "请先到用药管理添加药物，再登记库存。": {
      "en": "Add a medication before recording stock.",
      "de": "Vor der Bestandserfassung ein Medikament hinzufügen.",
    },
    "请先导出并检查备份文件，再尝试恢复。导入会替换当前浏览器中的全部记录，不会自动合并。": {
      "en": "Export and verify a backup first. Restoring replaces local records without merging.",
      "de": "Zuerst ein Backup exportieren und prüfen. Die Wiederherstellung ersetzt lokale Einträge ohne Zusammenführung.",
    },
    "请填写有效日期（yyyy-MM-dd HH:mm）和结果": {
      "en": "Enter a valid date (yyyy-MM-dd HH:mm) and result",
      "de": "Gültiges Datum (yyyy-MM-dd HH:mm) und Ergebnis eingeben",
    },
    "请填写症状名称": {"en": "Enter a symptom name", "de": "Symptomnamen eingeben"},
    "请选择检查医院": {"en": "Select a Hospital", "de": "Krankenhaus auswählen"},
    "调整每次剂量 / 频率": {
      "en": "Adjust Dose / Frequency",
      "de": "Dosis / Häufigkeit ändern",
    },
    "趋势图": {"en": "Trend Chart", "de": "Verlaufsgrafik"},
    "返回": {"en": "Back", "de": "Zurück"},
    "还没有症状记录，点击右下角开始添加。": {
      "en": "No symptom records yet. Use Add below.",
      "de": "Noch keine Symptomeinträge. Unten hinzufügen.",
    },
    "还没有这个指标的记录，请先去“检查结果”录入。": {
      "en": "No records for this indicator. Add one under Lab Results.",
      "de":
          "Keine Werte für diesen Messwert. Unter Laborergebnisse hinzufügen.",
    },
    "进入用药管理": {
      "en": "Open Medication Management",
      "de": "Medikamentenverwaltung öffnen",
    },
    "选择 CSV": {"en": "Select CSV", "de": "CSV auswählen"},
    "选择检查医院，然后导入 CSV 文件。": {
      "en": "Select a hospital, then import a CSV file.",
      "de": "Krankenhaus auswählen und CSV-Datei importieren.",
    },
    "部分点由 < / > 等界限结果换算，仅用于显示趋势，不代表实测值。": {
      "en": "Some limit values are approximated for charts; not actual measurements.",
      "de": "Einige Grenzwerte werden nur zur Darstellung angenähert, nicht gemessen.",
    },
    "采样时间": {"en": "Sample Date", "de": "Probenzeit"},
    "重复记录管理": {
      "en": "Duplicate Record Management",
      "de": "Duplikate verwalten",
    },
    "重要：请先分别导出 Mac 和 iPhone 的 JSON 备份。首次配对时，如果两端已有不同医疗记录，系统不会自动合并。": {
      "en": "Important: Back up both devices first. Different records are not merged automatically.",
      "de": "Wichtig: Beide Geräte zuerst sichern. Unterschiedliche Einträge werden nicht automatisch zusammengeführt.",
    },
    "附件保存于当前浏览器的 SQLite 数据库，并包含在完整 JSON 备份中。单个文件最多 8 MB。": {
      "en": "Attachments are stored in this browser's SQLite and full JSON backups. Max 8 MB each.",
      "de": "Anhänge liegen in der lokalen SQLite-Datenbank und im JSON-Backup. Maximal 8 MB je Datei.",
    },
    "预设检查指标": {"en": "Preset Indicators", "de": "Vordefinierte Laborwerte"},
    "首次修改会保存原始 CSV 字段快照。修改仅影响数据库，不会改动 CSV 文件。": {
      "en": "First edit preserves a snapshot of the original CSV fields. Only the database changes.",
      "de": "Bei der ersten Änderung werden CSV-Originalfelder gesichert. Nur die Datenbank ändert sich.",
    },
    "首页": {"en": "Home", "de": "Startseite"},
    "首页仅展示已有记录，不提供诊断或调整用药建议。": {
      "en": "Home displays records only, not diagnoses or medication advice.",
      "de": "Startseite zeigt nur Einträge, keine Diagnosen oder Therapieempfehlungen.",
    },
  };

  static String translate(BuildContext context, String original) {
    final language = Localizations.localeOf(context).languageCode;
    if (language == 'zh') return original;
    return translations[original]?[language] ?? original;
  }
}

/// Const-compatible replacement for static Text widgets.
/// It does not translate user-entered data, values, or interpolated strings.
class LText extends Text {
  const LText(
    super.data, {
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaler,
    super.maxLines,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionColor,
  });

  @override
  Widget build(BuildContext context) => Text(
    UiI18n.translate(context, data ?? ''),
    key: key,
    style: style,
    strutStyle: strutStyle,
    textAlign: textAlign,
    textDirection: textDirection,
    locale: locale,
    softWrap: softWrap,
    overflow: overflow,
    textScaler: textScaler,
    maxLines: maxLines,
    semanticsLabel: semanticsLabel,
    textWidthBasis: textWidthBasis,
    textHeightBehavior: textHeightBehavior,
    selectionColor: selectionColor,
  );
}
