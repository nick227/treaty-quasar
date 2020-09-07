<template>
  <div>
  <q-item>
    <q-item-section top avatar>
      <q-avatar color="negative" text-color="white" icon="error" />
    </q-item-section>
    <q-item-section>
      <q-item-label class="text-grey-9"><small>{{ organization }} grievance</small></q-item-label>
      <q-item-label>{{ title }}</q-item-label>
      <q-item-label @click="showMore" caption lines="200">{{ description }}</q-item-label>
    </q-item-section>
    <q-item-section side top>
      <q-icon name="thumb_up_alt" v-ripple color="blue" class="cursor-pointer" /><span class="text-weight-bolder">634</span>
    </q-item-section>
    <q-item-section side top>
      <q-icon name="thumb_down_alt" v-ripple color="red" class="cursor-pointer" /> <span class="text-weight-bold">33</span>
    </q-item-section>
    </q-item>
    <CommentsWidget
          :entityId="id"
          type="grievance"
    ></CommentsWidget>
        <q-separator spaced inset />
</div>
</template>
<script>
import CommentsWidget from 'components/CommentsWidget.vue'
export default {
  name: 'GrievanceList',
  components: { CommentsWidget },
  methods: {
    showComments: function (event) {
      console.log(event)
    },
    showMore: function (e) {
      console.log(e)
      e.target.lines = 25
    }
  },
  data () {
    return {}
  },
  props: {
    id: {
      type: Number,
      required: true
    },
    title: {
      type: String,
      required: true
    },
    description: {
      type: String,
      required: true
    },
    organization: {
      type: String,
      required: true
    }
  }
}

</script>
