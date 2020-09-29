<template>
  <q-list>
  <q-item v-for="item in navItems"
    clickable
    v-ripple
    :tag="item.tagType"
    :to="item.href ? item.href : null"
    :key="item.name"
    v-show="item.visible"
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
        { tagType: 'a', iconName: 'home', href: '/', fn: false, text: 'Home', visible: true },
        { tagType: 'a', iconName: 'flash_on', href: '/conflicts', fn: false, text: 'Conflicts', visible: true },
        { tagType: 'a', iconName: 'article', href: '/treaties', fn: false, text: 'Treaties', visible: true },
        { tagType: 'a', iconName: 'public', href: '/organizations', fn: false, text: 'Organizations', visible: true },
        { tagType: 'a', iconName: 'whatshot', href: '/conversation', fn: false, text: 'Conversation', visible: true },
        { tagType: 'a', iconName: 'email', href: '/messages', fn: false, text: 'Messages', visible: true },
        { tagType: 'a', iconName: 'login', href: '/login', fn: false, text: 'Login', visible: !this.$store.state.user.uid },
        { tagType: 'a', iconName: 'logout', fn: this.logout, text: 'Logout', visible: this.$store.state.user.uid }
      ],
      active: 'Home'
    }
  },
  methods: {
    logout () {
      this.$store.commit('user/updateUid', null)
      this.$store.commit('user/updateAvatar', null)
      if (this.$hello.getAuthResponse('facebook') == null) {
        this.$router.push('/')
        return false
      }
      this.$hello('facebook').logout().then(function () {
        window.location.href = '/'
      }, function (e) {
        alert('Signed out error: ' + e.error.message)
      })
    },
    isLoggedIntoFb () {
      this.$hello('facebook').api('me')
        .then((res) => {
          console.log(res)
        })
    }
  }
}
</script>
