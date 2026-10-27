# 文字选区配色

“设置 → 文字 → 选中文字颜色”提供自动搭配、白色和黑色。修改立即刷新所有便签；五张卡片显示不透明预设便签的配色。字体设置仍仅影响新窗口。

配色统一由 `ExStickySelectionPalette` 计算：转换为 sRGB，保留 H，深色和浅色候选的饱和度分别为 S×0.60 和 S×0.15，用 18 次二分搜索逼近相对亮度 0.045 和 0.82。候选达不到目标时取最大亮度。所有输出颜色均不透明。

自动模式比较候选与便签的对比度；便签 alpha 小于 0.6 时优先深色，这是针对浅色桌面的实用处理，并不识别实际桌面。白色和黑色模式分别固定使用深色和浅色选区。设置保存于 `exsticky.text.selectionTextColor`，缺失或无效值回退到自动模式。

失焦保留全部 `selectedRanges`，使用系统失焦选区颜色，并通过 layout manager 的临时前景色属性保证文字清晰。重新聚焦、选区变化或刷新时清理临时属性，按当前 UTF-16 长度裁剪清理范围。正文内容和实际颜色不变。

## 验证

2026-10-27，在本机 Apple Silicon、Swift 6.1.2 上验证：

- 完整应用 Swift 源码可编译、链接；保持 macOS 12.1 部署目标及 Swift 5 语言模式。
- 12 个色相 × 5 个饱和度 × 4 个亮度 × 3 个 alpha × 3 种模式，共 2160 组；最低文字对比度 10.07:1。
- 五种不透明预设的自动配色色值符合设计，选区与便签对比度均超过 3:1。
- 包含自定义颜色、P3 输入、无法达到目标亮度的候选、alpha 0.59/0.6 边界。
- 设置缺失/无效值回退、三种模式跨进程读取、底色及透明度刷新、多选区失焦/聚焦、取消选择、包含 emoji 的 UTF-16 范围和文本缩短后的清理均通过原生 AppKit 检查。
- 用独立测试进程检查中文设置布局、三种模式的实时预览，以及失焦后保留的选区。测试进程使用独立标识，没有替换安装版或改动正在编辑的便签。

回归检查需要项目 `Package.resolved` 对应版本的 XCLog 源码（revision `c7df5ce4b0fccf4eccd78d81a646302bcb1f374f`）：

```sh
python3 Tests/run-selection-checks.py /path/to/XCLog/Sources/XCLog/XCLog.swift
```

测试需要可以写入测试程序自身的 UserDefaults 偏好域，才能验证跨进程持久化；受限沙盒内仅内存读写成功不能替代这一项。

## 构建与替换安装

2026-10-27 已在本机用 Swift 命令行编译器分别编译 arm64 和 x86_64，合并为通用程序；沿用原安装包的已编译菜单、图标等资源，更新中英文本地化后打包为 2026.10.27（2026102701）。已备份原应用及沙盒数据，替换 `/Applications/ExSticky.app`，验证签名、原沙盒权限、启动、新选区设置和预览，以及既有字体和字号读取。保持原标识 `com.yangxijie.exsticky.beta`，使用与原安装包一致的本地 ad-hoc 签名及 hardened runtime。

本机没有完整 Xcode，未执行 Xcode 归档或 Intel 机器实机运行验证。后续也可以在目标电脑用完整 Xcode 从源码构建：

```sh
xcodebuild -project ExSticky.xcodeproj -scheme ExSticky \
  -configuration Release -destination 'platform=macOS' \
  -derivedDataPath /tmp/ExSticky-build build
```

先保存当前便签正文并退出旧版，备份原应用后再替换。保持项目原标识 `com.yangxijie.exsticky.beta`、App Sandbox 和用户选择文件只读权限；不要用独立测试标识安装替换。替换后检查应用签名、启动、已有设置读取及选区效果。另一架构的产物和真实桌面上的透明效果仍需在目标电脑验证。
