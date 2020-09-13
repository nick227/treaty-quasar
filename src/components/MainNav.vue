<template>
  <q-list>
  <q-item v-for="item in navItems"
    clickable
    :tag="item.tagType"
    :to="item.href"
    :key="item.name"
    @click="item.fn ? item.fn() : null"
  >
    <q-item-section avatar>
      <q-icon :name="item.iconName" />
    </q-item-section>
    <q-item-section>
      <q-item-label>{{ item.text }}</q-item-label>
    </q-item-section>
  </q-item>
</q-list>
</template>

<script>
export default {
  name: 'MainNav',
  data () {
    const self = this
    return {
      navItems: [
        { tagType: 'a', iconName: 'home', href: '/', fn: false, text: 'Home' },
        { tagType: 'a', iconName: 'article', href: '/treaties', fn: false, text: 'Treaties' },
        { tagType: 'a', iconName: 'public', href: '/organizations', fn: false, text: 'Organizations' },
        { tagType: 'a', iconName: 'person', href: '/members', fn: false, text: 'Members' },
        { tagType: 'a', iconName: 'login', href: '/login', fn: false, text: 'Login' },
        { tagType: 'a', iconName: 'logout', href: '/', fn: function () { self.logout() }, text: 'Logout' }
      ]
    }
  },
  mounted () {},
  methods: {
    logout () {
      if (this.$hello.getAuthResponse('facebook') == null) {
        return
      }
      this.$hello('facebook').logout().then(function () {
        this.$store.commit('user/updateUid', null)
        this.$router.push('/login')
      }, function (e) {
        alert('Signed out error: ' + e.error.message)
      })
    },
    isLoggedIn () {
      this.$hello('facebook').api('me')
        .then((res) => {
          // this.profile = res
        })
    }
  }
}
</script>
