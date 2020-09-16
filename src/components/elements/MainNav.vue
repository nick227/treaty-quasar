<template>
  <q-list>
  <q-item v-for="item in navItems"
    clickable
    v-ripple
    :tag="item.tagType"
    :to="item.href ? item.href : null"
    :key="item.name"
    @mouseover="miniState = false"
    @mouseout="miniState = true"
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
    return {
      navItems: [
        { tagType: 'a', iconName: 'home', href: '/', fn: false, text: 'Home' },
        { tagType: 'a', iconName: 'article', href: '/treaties', fn: false, text: 'Treaties' },
        { tagType: 'a', iconName: 'public', href: '/organizations', fn: false, text: 'Organizations' },
        { tagType: 'a', iconName: 'person', href: '/members', fn: false, text: 'Members' },
        { tagType: 'a', iconName: 'login', href: '/login', fn: false, text: 'Login' },
        { tagType: 'a', iconName: 'logout', fn: this.logout, text: 'Logout' }
      ],
      active: 'Home'
    }
  },
  mounted () {},
  methods: {
    logout () {
      if (this.$hello.getAuthResponse('facebook') == null) {
        this.$router.push('/')
        return false
      }
      this.$hello('facebook').logout().then(function () {
        this.$store.commit('user/updateUid', null)
        this.$store.commit('user/updateAvatar', null)
        window.location.href = '/'
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
