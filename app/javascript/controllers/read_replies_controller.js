import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "reply", "show", "hidden" ]

  connect() {
    //初始只显示三个
    this.hiddenExtraReplies()
    //当回复不多于三个时不显示show按钮
    if (this.replyTargets.length <= 3) {
      this.showTarget.classList.add('d-none')
    }
  }
  //将第三个以后的回复隐藏起来
  hiddenExtraReplies() {
    this.index = 0
    let extraReplies = this.replyTargets.slice(3)
    //如果不足三个回复则不做任何动作
    if (extraReplies.length != 0) {
      extraReplies.forEach((reply) => {
        reply.classList.add("d-none")
      })
    }
    //隐藏hidden按钮
    this.hiddenTarget.classList.add('d-none')
    //显示show按钮
    this.showTarget.classList.remove('d-none')
  }
  //显示下三个回复
  showExtraReplies() {
    this.index += 3
    let index = this.index
    let extraReplies = this.replyTargets.slice(index, index + 3)
    if (extraReplies.length != 0) {
      extraReplies.forEach((reply) => {
        reply.classList.remove("d-none")
      })
    }
    //显示hidden按钮
    this.hiddenTarget.classList.remove('d-none')
    //如果没有剩余的reply 则隐藏show 按钮
    if (this.replyTargets.length <= index + 3) {
      this.showTarget.classList.add('d-none')
    }
  }

  get index() {
    return parseInt(this.data.get("index"))
  }

  set index(value) {
    this.data.set("index", value)
  }
}
