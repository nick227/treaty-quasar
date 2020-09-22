// import something here
import { Notify } from 'quasar'
import storeFn from '../store'
const store = storeFn()
const errorMessages = {
  loginError: 'Please login to continue',
  orgError: 'You must join an organization'
}
export default async ({ Vue }) => {
  const handler = {
    loggedInCheck: function () {
      if (typeof store.state.user.uid !== 'number') {
        Notify.create({
          type: 'negative',
          icon: 'error',
          message: errorMessages.loginError
        })
        return false
      }
      return true
    },
    isLoggedInUser: function (uid) {
      return uid === store.state.user.uid
    },
    organizationCheck: function (key) {
      if (!this.loggedInCheck()) {
        return false
      }
      if (typeof key !== 'number') {
        Notify.create({
          type: 'negative',
          icon: 'error',
          message: errorMessages.orgError
        })
        return false
      }
      return true
    }
  }
  Vue.prototype.$errorHandler = handler
}
