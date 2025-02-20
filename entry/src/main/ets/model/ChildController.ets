import Log from "../common/utils/Log"

class ChildController {
  private childs = new Map<string, () => void>()

  register = (name: string, handler: () => void) => {
    //Log.debug(`register name: ${name.toLowerCase()}`)
    this.childs.set(name.toLowerCase(), handler)
  }

  call = (name: string) => {
    //Log.debug(`call name: ${name.toLowerCase()}`)
    let handler = this.childs.get(name.toLowerCase())
    if (handler) {
      handler()
    }
  }
}

export let childController = new ChildController()