# AI言い訳メーカー

SwiftUI製のAI風ジョークアプリです。外部AI APIは使わず、ローカルのテンプレート・単語辞書・ランダム合成だけで言い訳を生成します。

## 方針

- OpenAI APIなど外部AI APIなし
- サーバー通信なし
- ユーザー登録なし
- 個人情報保存なし
- 履歴はUserDefaultsに保存
- AdMobは差し替え用の広告枠だけ実装

## AdMob差し替えメモ

今は `AdService.isAdMobEnabled` を `false` にして、画面には「広告スペース」を表示しています。

実広告を入れる時は、Google Mobile Ads SDKを追加し、`AdMobBannerSlotView` の中身をSDKのバナーViewに差し替えてください。画面側は `AdMobBannerSlotView(placement:)` を呼ぶだけにしてあります。
