<template>
  <q-item>
    <q-item-section top avatar>
      <q-avatar color="positive" text-color="white" icon="insights" />
    </q-item-section>
    <q-item-section>
      <q-item-label>{{ title }}</q-item-label>
      <q-item-label caption lines="2">{{ description }}</q-item-label>
    </q-item-section>
    <q-item-section side top>
      <table class="cursor-pointer" @click="showComments"><tr><td><q-icon name="comment" color="blue" /></td><td>13</td></tr></table>
    </q-item-section>
  </q-item>
</template>
<script>
export default {
  name: 'OfferList',
  methods: {
    showComments: function (event) {
      alert('test clicked')
    }
  },
  props: {
    title: {
      type: String,
      required: true
    },
    description: {
      type: String,
      required: true
    }
  }
}

</script>
