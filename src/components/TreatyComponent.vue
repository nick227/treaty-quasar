<template>
  <div>
  <q-item>
    <q-item-section top>
      <q-item-label class="text-grey-9"><small>{{ organization }} {{ entityType }}</small></q-item-label>
      <q-item-label><h5 class="q-pt-none">{{ title }}</h5></q-item-label>
      <q-item-label caption lines="200">{{ description }}</q-item-label>
    </q-item-section>
    <q-item-section side top style="width:95px;">
      <div class="text-center full-width">{{ orgAname }}</div>
      <LikeButtons
      :entityType='entityType'
      :entityId="id" />
      <q-separator class="q-mt-sm" />
      <div class="q-mt-sm text-center full-width">{{ orgBname }}</div>
      <LikeButtons
      :entityType='entityType'
      :entityId="id" />
    </q-item-section>
    </q-item>
    <CommentsWidget
          :entityId="id"
          :entityType="entityType"
    ></CommentsWidget>
        <q-separator spaced inset />
</div>
</template>
<script>
import CommentsWidget from 'components/CommentsWidget.vue'
import LikeButtons from 'components/LikeButtons.vue'
export default {
  name: 'TreatyComponent',
  components: { CommentsWidget, LikeButtons },
  methods: {
    showComments: function (event) {
      console.log(event)
    },
    showMore: function (e) {
      console.log(e)
      e.target.lines = 25
    }
  },
  mounted () {},
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
    entityType: {
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
    },
    orgAname: {
      type: String,
      required: false
    },
    orgBname: {
      type: String,
      required: true
    }
  }
}

</script>
