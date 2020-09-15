export const ErrorHelper = {
  data () {
    return {}
  },
  methods: {
    isValid: function (type, val) {
      const messages = {
        organization: 'You must join an organization'
      }
      if (typeof val !== 'number') {
        this.$q.notify({
          type: 'negative',
          icon: 'error',
          message: messages[type]
        })
        return false
      }
      return true
    }
  }
}
