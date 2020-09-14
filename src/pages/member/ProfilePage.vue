<template>
  <q-page class="full-width full-height" :style="'background-image:url(' + this.user.profile_background_url + ');'">
<q-card class="q-pa-lg full-width full-height  bg-semi-trans">
      <q-card-section horizontal class="full-width">
      <q-avatar size="250px" class="q-mr-md q-mb-lg items-start">
        <q-img
          class="self-start"
          :src="user.avatar_url"
          style="max-height:80vh"
        />
      </q-avatar>
        <q-card-section class="q-pb-md q-pt-none">
          <h2>{{ user.name }}</h2>
          <h4 class="q-pt-none">{{ user.location }}</h4>
          <p class="q-pt-none" style="max-width:60%;">{{ user.biography }}</p>
        </q-card-section>
        <q-expansion-item v-model="expanded" switch-toggle-side dense-toggle label="Edit Profile" class="absolute-right z-top q-mb-lg q-mb-lg">
          <EditProfileWidget
           :name="user.name"
           :avatar_url="user.avatar_url"
           :location="user.location"
           :biography="user.biography"
           :profile_background_url="user.profile_background_url"
           :uid="user.id"
           :reload="reload"
           />
        </q-expansion-item>
      </q-card-section>
      <q-separator />
      <h6 v-if="orgs.length" class="q-mt-lg q-ml-lg">Member of:</h6>
    <div class="row q-pa-lg justify-start content-start">
      <div class="col col-shrink" v-for="org in orgs" :key="org.id">
        <q-card class="org-card flex-break q-mr-md transparent">
      <img :src="org.avatar_url">
      <q-card-section>
        <div class="text-h6">{{ org.name }}</div>
        <div class="text-subtitle2">{{ org.description }}</div>
      </q-card-section>
      <q-card-section class="q-pt-none">
        <q-btn :to="'/organization/'+org.id" class="full-width" color="primary">PROFILE</q-btn>
      </q-card-section>
    </q-card>
      </div>
    </div>
    </q-card>
    </q-page>
</template>
<script>
import EditProfileWidget from 'components/profile/EditProfileWidget.vue'
export default {
  meta () {
    return {
      title: this.user.name
    }
  },
  components: { EditProfileWidget },
  name: 'Profile',
  data () {
    return {
      user: {},
      orgs: {},
      style: '',
      expanded: false
    }
  },
  async created () {
    this.getProfile()
    this.getOrganizations()
  },
  methods: {
    reload: async function () {
      this.expanded = false
      this.getProfile()
    },
    getProfile: async function () {
      const q = `${process.env.api}/users/${this.$route.params.id}`
      const user = await this.$axios.get(q)
      this.user = user.data
    },
    getOrganizations: async function () {
      const q = `${process.env.api}/users/${this.$route.params.id}/organizations`
      const orgs = await this.$axios.get(q)
      this.orgs = orgs.data
    }
  }
}
</script>
