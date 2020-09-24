<template>
  <div>
    <q-expansion-item dense-toggle icon="comment" :label="capitalize(entityType) + ' Comments ' + commentCount" class="bg-grey-trans" @click="loadComments">
      <div class="q-pa-md full-width">
        <q-form @submit="postComment">
          <q-input filled type="textarea" required autogrow class="bg-grey-5" placeholder="Type comment here" v-model="newComment" :key="entityId" />
          <div class="row">
            <q-space />
            <q-btn type="submit" color="primary q-mt-lg">submit</q-btn>
          </div>
        </q-form>
      </div>
      <q-separator />
      <q-list>
        <div v-if="!comments.length" class="text-center q-pa-lg">no comments</div>
        <q-item style="border-bottom:1px solid rgba(0, 0, 0, 0.12)" class="q-pl-lg q-pr-lg q-ma-sm" v-for="comment in readyComments" :key="comment.id">
          <q-item-section top avatar>
            <q-avatar round size="75px" class="q-mr-md">
              <img round class="avatar" :src="comment.creator.avatar_url" />
            </q-avatar>
          </q-item-section>
          <q-item-section>
            <q-item-label caption>{{ comment.create_date }}</q-item-label>
            <q-item-label class="text-h6">{{ comment.creator.name }}</q-item-label>
            <q-item-label lines="10" v-html="comment.text"></q-item-label>
          </q-item-section>
            <div class="float-right">
             {{ comment_likes_amounts[comment.id] }} <q-rating
                v-model="comment_likes[comment.id]"
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
        </q-item>
        <q-btn @click="showMore" v-if="this.currentPointer + this.limit <= this.commentCount" class="full-width text-center">show more</q-btn>
      </q-list>
    </q-expansion-item>
  </div>
</template>
<script>
import { date } from 'quasar'
export default {
  name: 'CommentsWidget',
  mounted () {
    this.getCommentCount()
  },
  data () {
    return {
      comment_likes_amounts: {},
      comment_likes_obj: {},
      comment_likes: {},
      comments: [],
      newComment: '',
      currentPointer: 0,
      limit: 5,
      commentCount: '',
      loaded: false
    }
  },
  props: {
    entityId: {
      type: Number,
      required: true
    },
    entityType: {
      type: String,
      required: true
    }
  },
  computed: {
    readyComments: function () {
      const embedHtml = '<iframe type="text/html" width="480" height="320" src="http://www.youtube.com/embed/embed_code_target" frameborder="0"></iframe>'
      return this.comments.map((comment) => {
        const ytMatch = comment.text.match(/(http:|https:)?(\/\/)?(www\.)?(youtube.com|youtu.be)\/(watch|embed)?(\?v=|\/)?(\S+)?/)
        comment.text = ytMatch ? comment.text.replace(ytMatch[0], function (a, b) { return embedHtml.replace('embed_code_target', ytMatch[7].split('&')[0]) }) : comment.text
        comment.text = comment.text.replaceAll('<script>', '')
        comment.create_date = date.formatDate(comment.create_date, 'MMM Do, YYYY')
        return comment
      })
    }
  },
  methods: {
    like: async function (commentId) {
      let q = ''
      let method = ''
      const key = this.entityType + '_comment_id'
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        liked: this.comment_likes[commentId]
      }
      payload[key] = commentId
      if (typeof this.comment_likes_obj[commentId] === 'object') {
        q = `${process.env.api}/${this.entityType}-comment-likes/${this.comment_likes_obj[commentId][0].id}`
        method = 'patch'
      } else {
        q = `${process.env.api}/${this.entityType}-comment-likes`
        method = 'post'
      }
      console.log(q)
      console.log(payload)
      await this.$axios.[method](q, payload, { headers: { Accept: 'application/json' } })
        .then((res) => {
          this.getComments()
          this.$q.notify({
            type: 'positive',
            message: 'Update Success'
          })
        })
        .catch((err) => {
          this.$q.notify({
            type: 'negative',
            message: 'Error saving: ' + err
          })
        })
    },
    setupLikes: function () {
      for (let i = 0; i < this.comments.length; i++) {
        const commentLikes = typeof this.comments[i].likes === 'object' ? this.comments[i].likes.filter((o) => o.creator_user_id === this.$store.state.user.uid).map((o) => { return o.liked }) : []
        this.comment_likes[this.comments[i].id] = typeof commentLikes[commentLikes.length - 1] === 'number' ? commentLikes[commentLikes.length - 1] : 0
        this.comment_likes_amounts[this.comments[i].id] = typeof this.comments[i].likes === 'object' ? this.comments[i].likes.filter((o) => { return o.liked === 1 }).length : 0
        if (typeof this.comments[i].likes === 'object') {
          this.comment_likes_obj[this.comments[i].id] = this.comments[i].likes.filter((o) => { return o.creator_user_id === this.$store.state.user.uid })
        }
      }
    },
    loadComments: function () {
      if (!this.loaded) {
        this.getComments()
        this.loaded = true
      }
    },
    capitalize: function (str) {
      return str.charAt(0).toUpperCase() + str.slice(1)
    },
    getComments: async function () {
      const q = `${process.env.api}/${this.entityType}-comments/?filter[skip]=${this.currentPointer}&filter[limit]=${this.limit}&filter[where][${this.entityType}_id]=${this.entityId}&filter[include][0][relation]=creator&filter[include][1][relation]=likes&filter[order]=create_date%20DESC`
      const comments = await this.$axios.get(q)
      this.comments = comments.data
      this.setupLikes()
    },
    showMore: async function () {
      this.currentPointer = this.currentPointer + this.limit
      const q = `${process.env.api}/${this.entityType}-comments/?filter[skip]=${this.currentPointer}&filter[limit]=${this.limit}&filter[where][${this.entityType}_id]=${this.entityId}&filter[include][0][relation]=creator&filter[include][1][relation]=likes&filter[order]=create_date%20DESC`
      const comments = await this.$axios.get(q)
      this.comments = this.comments.concat(comments.data)
    },
    getCommentCount: async function () {
      const q = `${process.env.api}/${this.entityType}-comments/count?[where][${this.entityType}_id]=${this.entityId}`
      const res = await this.$axios.get(q)
      this.commentCount = res.data.count
    },
    postComment: async function () {
      const q = `${process.env.api}/${this.entityType}-comments`
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        text: this.newComment
      }
      payload[this.entityType + '_id'] = this.entityId
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
      this.newComment = ''
      this.getComments()
      this.getCommentCount()
    }
  }
}

</script>
