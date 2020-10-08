<template>
  <q-page class="justify-center profile-avatar animated fadeIn" :style="'background-image:url(' + this.user.profile_background_url + '); flex-center;display:flex;'">
    <div class="river-width self-center">
      <div class="row relative-position" v-if="isUser">
        <q-expansion-item v-model="expanded" switch-toggle-side dense-toggle label="Edit Profile" class="absolute-right z-top q-pr-lg q-mr-lg">
          <EditProfileWidget :name="user.name" :avatar_url="user.avatar_url" :location="user.location" :biography="user.biography" :profileBackgroundUrl="user.profile_background_url" :uid="user.id" :reload="reload" />
        </q-expansion-item>
      </div>
      <q-card class="q-pa-lg full-width full-height bg-semi-trans">
        <q-card-section class="full-width row mobile-row">
          <div class="col col-8">
            <transition appear enter-active-class="animated fadeIn" leave-active-class="animated fadeOut">
                <div :style="'width:100%; min-height:400px;background-image:url(' + user.avatar_url + ')'" class="avatar-image"></div>
            </transition>
          </div>
          <div class="col col-4">
            <div class="q-pl-md">
              <h5>{{ user.name }}</h5>
              <p class="q-pa-none q-ma-none text-caption">Location: {{ user.location }}</p>
              <p class="q-pa-none q-ma-none" style="max-width:98%;">{{ user.biography }}</p>
              <q-btn @click="openSendMessage" style="height:40px;" class="q-mt-md" square color="dark">
                <q-icon left size="2em" name="mail" />
                <div>Message</div>
              </q-btn>
            </div>
          </div>
          </q-card-section>
          <q-card-section class="q-pb-md q-pt-none">
            <div v-if="achievements.length">
              <h6 class="q-mt-lg q-ml-lg">Achievements:</h6>
              <div class="row q-pa-lg justify-start content-start">
                <div class="q-mb-md" style="width:33.333%" v-for="achievement in readyAchievements" :key="achievement.id">
                  <table>
                    <tr>
                      <td>
                        <q-img class="q-mr-sm" style="width:50px;" :src="achievement.avatar_url" /></td>
                      <td class="text-caption">{{ achievement.total }} {{ achievement.name }}
                        <BR />({{ achievement.total * achievement.point_value }} points)</td>
                    </tr>
                  </table>
                </div>
              </div>
            </div>
        </q-card-section>
        <q-separator />
        <CommentsWidget :key="'comments' + counter" v-if="user.id" :entityId="user.id" entityType="user"></CommentsWidget>
        <q-separator />
        <h6 class="q-mt-lg q-ml-lg">Treaties:</h6>
        <div class="row q-pa-lg justify-start content-start">
          <p v-if="!treaties.length">No Treaties</p>
          <div class="col col-shrink q-ma-sm card-item" v-for="treaty in treaties" :key="treaty.id">
            <q-card class="flex-break q-mr-md transparent card-item">
              <router-link :to="'/treaty/'+treaty.id">
                <div :style="'background-image:url(' + treaty.avatar_url + ')'" class="card-image"></div>
              </router-link>
              <q-card-section>
                <div class="text-h6 ellipsis-2-lines">{{ treaty.name }}</div>
              </q-card-section>
              <q-card-section class="q-pt-none">
                <q-btn :to="'/treaty/'+treaty.id" class="full-width" color="dark">VISIT</q-btn>
              </q-card-section>
            </q-card>
          </div>
        </div>
        <q-separator v-if="orgs.length" />
        <h6 class="q-mt-lg q-ml-lg">Member of:</h6>
        <div class="row q-pa-lg justify-start content-start">
          <p v-if="!orgs.length">No Organizations</p>
          <div class="col col-shrink q-ma-sm card-item" v-for="org in orgs" :key="org.id">
            <q-card class="flex-break q-mr-md transparent card-item">
              <router-link :to="'/organization/'+org.id">
                <div :style="'background-image:url(' + org.avatar_url + ')'" class="card-image"></div>
              </router-link>
              <q-card-section>
                <div class="text-h6 ellipsis-2-lines">{{ org.name }}</div>
              </q-card-section>
              <q-card-section class="q-pt-none">
                <q-btn :to="'/organization/'+org.id" class="full-width" color="dark">VISIT</q-btn>
              </q-card-section>
            </q-card>
          </div>
        </div>
      </q-card>
      <q-dialog v-model="sendMessage">
        <MessageWidget :senderUserId="visitorUserId" :receiverUserId="user.id" :receiverName="user.name" :done="closeMsg" />
      </q-dialog>
    </div>
  </q-page>
</template>
<script>
import MessageWidget from 'components/widgets/MessageWidget.vue'
import CommentsWidget from 'components/widgets/CommentsWidget.vue'
import EditProfileWidget from 'components/profile/EditProfileWidget.vue'
export default {
  meta () {
    return {
      title: this.user.name
    }
  },
  components: { EditProfileWidget, CommentsWidget, MessageWidget },
  name: 'Profile',
  data () {
    return {
      treaties: [],
      user: {},
      orgs: {},
      achievements: [],
      style: '',
      counter: 0,
      expanded: false,
      sendMessage: false,
      visitorUserId: this.$store.state.user.uid,
      isUser: false,
      testColor: 'green'
    }
  },
  async created () {
    this.getProfile()
    this.getOrganizations()
    this.getTreaties()
    this.getAchievements()
  },
  computed: {
    readyAchievements: function () {
      console.log('km')
      const res = []
      let achievement = null
      let index = null
      for (let i = 0; i < this.achievements.length; i++) {
        achievement = this.achievements[i].type
        index = res.length ? res.findIndex(obj => obj.name === achievement.name) : -1
        if (index > -1) {
          console.log('aaaaaaa')
          res[index].total++
        } else {
          console.log('bbbbbbbb')
          achievement.total = 1
          res.push(achievement)
        }
      }
      console.log(res)
      return res
    }
  },
  methods: {
    getAchievements: async function () {
      const q = `${process.env.api}/user-achievements?filter[where][owner_user_id]=${this.$route.params.id}&filter[include][0][relation]=type`
      const achievements = await this.$axios.get(q)
      this.achievements = achievements.data
    },
    openSendMessage: function () {
      if (!this.$errorHandler.loggedInCheck()) { return false }
      this.sendMessage = true
    },
    closeMsg: function () {
      this.sendMessage = false
    },
    reload: async function () {
      this.expanded = false
      this.getProfile()
    },
    getProfile: async function () {
      const q = `${process.env.api}/users/${this.$route.params.id}`
      const user = await this.$axios.get(q)
      this.user = user.data
      this.isUser = this.$errorHandler.isLoggedInUser(this.user.id)
    },
    getOrganizations: async function () {
      const q = `${process.env.api}/users/${this.$route.params.id}/organizations`
      const orgs = await this.$axios.get(q)
      this.orgs = orgs.data
    },
    getTreaties: async function () {
      const q = `${process.env.api}/users/${this.$route.params.id}/treaties`
      const treaties = await this.$axios.get(q)
      this.treaties = treaties.data
    }
  }
}
</script>
<style>
.q-page-container{
  padding-left:0 !important;
  padding-right:0 !important;
}
.q-page{
  width:100%;
}
</style>
