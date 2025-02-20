class ResponseBean<T> {

  status: number = -1

  msg: string = ""

  data?: T = undefined

}

export default ResponseBean
