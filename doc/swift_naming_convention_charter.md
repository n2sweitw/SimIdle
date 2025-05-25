### Swift 命名規則チャーター（v1.0）

---

命名は Swift および iOS の公式ライブラリ・フレームワークにおける慣例に従うこと

- 型名・メソッド名は Apple 純正の命名規則を参考にし、責務が明確で自然言語としても意味が通る名前を用いること
- `Manager`, `Handler`, `Interactor` のような抽象的かつ曖昧な型名は、明確な文脈と責務がある場合を除き避けること
- 命名には Swift の API Design Guidelines に従うこと
- 関数やメソッドには引数ラベルを適切に付け、関数呼び出しが自然言語として読めるように設計すること

#### 命名テンプレート

- 単一引数のメソッド
  ```swift
  func move(to point: CGPoint)
  func setTitle(with text: String)
  ```

- 複数引数のメソッド
  ```swift
  func updateProfile(with name: String, age: Int)
  func sendMessage(to recipient: User, body: String)
  ```

- ファクトリ・生成系
  ```swift
  static func makeButton(with style: ButtonStyle) -> Button
  static func createSession(for user: User) -> Session
  ```

- 状態変化を伴う操作（破壊的）
  ```swift
  mutating func reset()
  mutating func removeItem(at index: Int)
  ```

- 状態参照系（非破壊）
  ```swift
  func isVisible(for user: User) -> Bool
  func title(for section: Int) -> String?
  ```

