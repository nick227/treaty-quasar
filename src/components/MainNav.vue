<template>
  <q-list>
  <!-- new item -->
  <q-item
    clickable
    tag="a"
    to="/"
  >
    <q-item-section avatar>
      <q-icon name="home" />
    </q-item-section>
    <q-item-section>
      <q-item-label>Home</q-item-label>
    </q-item-section>
  </q-item>
  <!-- new item -->
  <q-item
    clickable
    tag="a"
    to="/treaties"
  >
    <q-item-section avatar>
      <q-icon name="article" />
    </q-item-section>
    <q-item-section>
      <q-item-label>Treaties</q-item-label>
    </q-item-section>
  </q-item>
  <!-- new item -->
  <q-item
    clickable
    tag="a"
    to="/organizations"
  >
    <q-item-section avatar>
      <q-icon name="public" />
    </q-item-section>
    <q-item-section>
      <q-item-label>Organizations</q-item-label>
    </q-item-section>
  </q-item>
  <!-- new item -->
  <q-item
    clickable
    tag="a"
    to="/login"
  >
    <q-item-section avatar>
      <q-icon name="login" />
    </q-item-section>
    <q-item-section>
      <q-item-label>Login</q-item-label>
    </q-item-section>
  </q-item>
  <!-- new item -->
  <q-item
    clickable
    tag="a"
    href="#"
    @click="logout()"
  >
    <q-item-section avatar>
      <q-icon name="logout" />
    </q-item-section>
    <q-item-section>
      <q-item-label>Logout</q-item-label>
    </q-item-section>
  </q-item>
  <!-- new item -->
</q-list>
</template>

<script>
export default {
  name: 'MainNav',
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
    }
  }
}
</script>
