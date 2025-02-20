import FlowType from "../enums/FlowType"
import toast from "../ui/Toast"
import Http from "../utils/Http"
import { HashMap } from "@kit.ArkTS"
import { hash } from "@kit.CoreFileKit"

/**
 * 标签
 */
export default class Tag {
  id: string = ""
  parentTagId: string = ""
  name: string = ""
  remark: string = ""

  constructor(id: string, parentTagId: string = "", name: string, remark: string) {
    this.id = id
    this.parentTagId = parentTagId
    this.name = name
    this.remark = remark
  }

  static toSheet(tag: Tag, onClick: (tag: Tag) => void): SheetInfo {
    return {
      title: tag.name,
      action: () => {
        onClick(tag)
      }
    }
  }


  private static tags: HashMap<FlowType, Array<Tag>> = new HashMap()

  /**
   * 加载所有标签
   */
  static async loadAll(type: FlowType): Promise<Array<Tag>> {
    let tags: Array<Tag>|undefined = Tag.tags.hasKey(type) ? Tag.tags.get(type) : undefined
    if (!tags) {
      tags = await Http.get<Array<Tag>>("/v1/tag/query", { type: type })
        .catch((error: object|string) => {
          if (typeof error == 'string') {
            toast(error)
          } else {
            toast("请求出错了，稍后再试吧~")
          }
          return undefined
        })
    }
    if (!tags) {
      tags = new Array()
    } else {
      Tag.tags.set(type, tags)
    }
    return tags || new Array()
  }

}
