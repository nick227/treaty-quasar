<template>
  <div>
  <q-item>
    <q-item-section top>
      <q-item-label class="text-grey-9"><small>{{ orgAid }}-{{ orgAname }} | {{ orgBid }}-{{ orgBname }} {{ entityType }}id:{{ entityId }}</small></q-item-label>
      <q-item-label><h5 class="q-pt-none">{{ title }}</h5></q-item-label>
      <q-item-label caption lines="200">{{ description }}</q-item-label>
    </q-item-section>
    <q-item-section side top style="width:95px;">
      <div class="text-center full-width">{{ orgAname }}</div>
      <LikeButtons
      :entityType='entityType'
      :entityId="entityId"
      :organizationId="orgAid" />
      <q-separator class="q-mt-sm" />
      <div class="q-mt-sm text-center full-width">{{ orgBname }}</div>
      <LikeButtons
      :entityType='entityType'
      :entityId="entityId"
      :organizationId="orgBid" />
    </q-item-section>
    </q-item>
    <CommentsWidget
          :entityId="entityId"
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
  data () {
    return {}
  },
  props: {
    entityId: {
      type: Number,
      required: true
    },
    organizationId: {
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
    },
    orgAid: {
      type: Number,
      required: false
    },
    orgBid: {
      type: Number,
      required: true
    }
  }
}

</script>
