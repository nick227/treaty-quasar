<template>
  <q-layout view="Lhh lpR fff" container class="bg-white full-width">
    <q-header class="z-max bg-grey">
      <q-toolbar>
        <q-toolbar-title class="q-pl-lg text-center">CONCORDANT.IO</q-toolbar-title>
        <q-btn flat v-close-popup round dense icon="close" />
      </q-toolbar>
    </q-header>
    <q-page-container>
      <q-page padding>
      <div class="row relative-position full-width" style="height: 35px;">
        <q-expansion-item v-model="expanded" switch-toggle-side dense-toggle label="Edit Debate" class="absolute-right z-100">
          <EditDebateWidget :title="debate.title" :avatar_url="debate.avatar_url" :description="debate.description" :id="debate.id" :reload="reload" :pageReload="pageReload" />
        </q-expansion-item>
      </div>
        <div class="q-pt-sm full-width q-mb-lg"><q-img class="q-mb-lg" :src="debate.avatar_url" /></div>
        <div class="row q-pr-lg q-mt-lg q-mb-lg">
          <div class="col col-2">
            <q-avatar class="comment-q-avatar" round><img v-if="debate.creator" :src="debate.creator.avatar_url" /></q-avatar>
          </div>
          <div class="col p-pl-lg">
            <div>{{ readyDate }}</div>
            <p class="text-h5 q-pa-none q-ma-none" v-if="debate.creator">{{ debate.creator.name }}:</p>
            <h6 class="q-pa-none">{{ debate.title }}</h6>
            <p class="q-pt-none">{{ debate.description }}</p>
          </div>
        </div>
        <q-separator />
        <div class="row">
          <q-expansion-item v-model="add_reply[0]" dense-toggle label="Add Response" style="z-index:5" class="full-width bg-grey-5 q-mb-lg text-right">
            <AddDebateComment
            :debateId="debate.id"
            parentId=0
            :reload="reload" />
          </q-expansion-item>
        </div>
        <div v-for="comment in debate.topComments" class="q-mb-lg" :key="comment.id">
        <div class="row q-pr-lg">
          <div class="col col-2"><q-avatar class="comment-q-avatar" round><img :src="comment.creator.avatar_url" /></q-avatar></div>
          <div class="col p-pa-none">
            <div class="float-right">
             {{ comment_likes_amounts[comment.id] }} <q-rating
                v-model="user_comment_likes[comment.id]"
                max="1"
                size="1.75em"
                color="red"
                color-selected="red-12"
                icon="favorite_border"
                icon-selected="favorite"
                icon-half="favorite"
                no-dimming
                @click="like(comment.id)"
              />
            </div>
            <div class="text-small">{{ comment.create_date }}</div>
            <p class="text-h5 q-pa-none">{{ comment.creator.name }}:</p>
            <p class="q-pt-none">{{ comment.text }}</p>
        </div>
        </div>
        <div class="row">
          <q-expansion-item v-model="add_reply[comment.id]" dense-toggle label="reply" style="z-index:4" class="full-width bg-blue-4 text-right q-mt-md q-pb-lg">
            <AddDebateComment
            :debateId="debate.id"
            :parentId="comment.id"
            :reload="reload" />
          <q-separator />
          </q-expansion-item>
        </div>
        <q-expansion-item v-if="debate.childKeys.indexOf(comment.id) > -1" class="text-right bg-grey-4 q-mb-md" :label="'replies ' + debate.childComments[comment.id].length">
          <div v-for="commentInner in debate.childComments[comment.id]" :key="commentInner.id" class="q-pl-lg q-pb-lg">
          <div class="row text-left bg-grey-4 q-pr-lg q-pb-lg">
            <div class="col col-2 text-center"><q-avatar class="comment-q-avatar-inner" round><img :src="comment.creator.avatar_url" /></q-avatar></div>
            <div class="col p-pa-none">
              <div class="float-right">
                {{ comment_likes_amounts[commentInner.id] }} <q-rating
                  v-model="user_comment_likes[commentInner.id]"
                  max="1"
                  size="1.75em"
                  color="red"
                  color-selected="red-12"
                  icon="favorite_border"
                  icon-selected="favorite"
                  icon-half="favorite"
                  no-dimming
                  @click="like(commentInner.id)"
                />
              </div>
              <div>{{ commentInner.create_date }}</div>
              <p class="text-h6 align-left q-pa-none ">{{ commentInner.creator.name }} replies:</p>
              <p class="q-pt-none q-pr-md align-left">{{ commentInner.text }}</p>
          </div>
          </div>
          <q-separator />
          </div>
        </q-expansion-item>
        </div>
      </q-page>
    </q-page-container>
  </q-layout>
</template>
<script>
import EditDebateWidget from 'components/debate/EditDebateWidget.vue'
import AddDebateComment from 'components/debate/AddDebateComment.vue'
import TextToolsMixin from 'components/mixins/TextToolsMixin.vue'
import { date } from 'quasar'
export default {
  name: 'DebateDialogComponent',
  mixins: [TextToolsMixin],
  props: ['debateId', 'userOrganizationId', 'pageReload'],
  components: { AddDebateComment, EditDebateWidget },
  data () {
    return {
      expanded: false,
      comments: [],
      debate: {},
      add_reply: [],
      user_comment_likes: {},
      comment_likes_amounts: {},
      comment_likes_obj: {}
    }
  },
  created () {
    this.getDebate()
  },
  computed: {
    readyDate: function () {
      return date.formatDate(this.debate.create_date, 'MMM Do, YYYY')
    },
    readyComments: function () {
      return this.debate.comments.map((comment) => {
        comment.text = this.checkStr(comment.text)
        comment.create_date = date.formatDate(comment.create_date, 'MMM Do, YYYY')
        return comment
      })
    }
  },
  methods: {
    like: async function (commentId) {
      let q = ''
      let method = ''
      const payload = {
        organization_id: this.userOrganizationId,
        creator_user_id: this.$store.state.user.uid,
        liked: this.user_comment_likes[commentId],
        debate_comment_id: commentId
      }
      if (typeof this.comment_likes_obj[commentId] === 'object') {
        q = `${process.env.api}/debate-comment-likes/${this.comment_likes_obj[commentId][0].id}`
        method = 'patch'
      } else {
        q = `${process.env.api}/debate-comment-likes`
        method = 'post'
      }
      await this.$axios.[method](q, payload, { headers: { Accept: 'application/json' } })
        .then((res) => {
          this.reload()
          this.$q.notify({
            type: 'positive',
            message: 'Like Success'
          })
        })
        .catch((err) => {
          this.$q.notify({
            type: 'negative',
            message: 'Error saving: ' + err
          })
        })
    },
    reload: function () {
      this.expanded = false
      this.getDebate()
      for (let i = 0; i < this.add_reply.length; i++) {
        this.add_reply[i] = false
      }
    },
    getDebate: async function () {
      const q = `${process.env.api}/debates/${this.debateId}?filter={"include":[{"relation":"creator"}, {"relation":"comments", "scope":{"include":[{"relation":"creator"}, {"relation":"likes"}]}}], "order": "create_date ASC"}`
      const debate = await this.$axios.get(q)
      this.debate = debate.data
      if (this.debate.comments) {
        this.setupLikes()
        this.sortComments()
      }
    },
    setupLikes: function () {
      for (let i = 0; i < this.debate.comments.length; i++) {
        const userLikes = typeof this.debate.comments[i].likes === 'object' ? this.debate.comments[i].likes.filter((o) => o.creator_user_id === this.$store.state.user.uid).map((o) => { return o.liked }) : []
        this.user_comment_likes[this.debate.comments[i].id] = typeof userLikes[userLikes.length - 1] === 'number' ? userLikes[userLikes.length - 1] : 0
        this.comment_likes_amounts[this.debate.comments[i].id] = typeof this.debate.comments[i].likes === 'object' ? this.debate.comments[i].likes.filter((o) => { return o.liked === 1 }).length : 0
        if (typeof this.debate.comments[i].likes === 'object') {
          this.comment_likes_obj[this.debate.comments[i].id] = this.debate.comments[i].likes.filter((o) => { return o.creator_user_id === this.$store.state.user.uid })
        }
      }
    },
    sortComments: function () {
      const childComments = this.readyComments.filter((obj) => { return obj.parent_comment_id })
      this.debate.childComments = {}
      this.debate.childKeys = []
      this.debate.topComments = this.readyComments.filter((obj) => { return !obj.parent_comment_id })
      this.debate.topComments.sort((a, b) => (a.create_date < b.create_date) ? 1 : -1)
      for (let i = 0; i < childComments.length; i++) {
        if (typeof this.debate.childComments[childComments[i].parent_comment_id] !== 'object') {
          this.debate.childComments[childComments[i].parent_comment_id] = []
        }
        this.debate.childComments[childComments[i].parent_comment_id].push(childComments[i])
        this.debate.childKeys.push(childComments[i].parent_comment_id)
      }
    }
  }
}
</script>
