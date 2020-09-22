<template>
  <div>
    <q-form @submit="search">
      <q-input class="q-pa-none" style="width:300px;" dark v-model="searchTerm" label="Search">
        <template v-slot:append>
          <q-icon v-ripple clickable class="cursor-pointer" @click="search" name="search" />
        </template>
      </q-input>
    </q-form>
  </div>
</template>
<script>
export default {
  name: 'SearchForm',
  components: {},
  data () {
    return {
      searchTerm: ''
    }
  },
  methods: {
    search: function () {
      console.log('searching:', this.searchTerm)
    }
  },
  mounted () {
    // console.log(this.$router.history.current.path)
  }
}
</script>
