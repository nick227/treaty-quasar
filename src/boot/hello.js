import hello from 'hellojs'

export default ({ Vue }) => {
  hello.init({
    facebook: '242471600360312'
  })
  Vue.prototype.$hello = hello
}
