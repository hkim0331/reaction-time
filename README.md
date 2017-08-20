# reaction-time

人間のリアクション時間は 100 msec 以下にはならんと陸上競技の人はいう。
本当か？そうじゃないアスリートが出てきたらどうすんの？
時代を遡って記録を認めることはできねーだろ。

## USAGE

```sh
$ racket reaction-time.rkt
```

の後、start ボタン、タイマー表示が回り始めるやいなや stop ボタンを押す。
タイマー回り始めてからボタン押すまでの時間を msec 単位で表示します。

start 押してからタイマー回るまでは
`(+ 1 (* 3 (random)))`
でスリープします。


## TODO

* play sound
  音の鳴り出しが遅れるみたいで、アプリの目的に沿わない。やめ。

* [done] pad zero
  1000 で割らずに、そのママ msec 値を表示する。

* [done] cancel exam when go clicked too early.
  let/cc の出番か？ 伝統的なフラグで対応。ダサい。

* display records

---
hkimura, 2017-08-20.
