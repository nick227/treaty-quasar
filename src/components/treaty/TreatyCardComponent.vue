<template>
  <q-card class="flex-break q-ma-lg">
    <div :style="'background-image:url(' + treaty.avatar_url + ')'" class="card-image"></div>
    <q-card-section>
      <div class="">{{ treaty.organization_a.name }} vs. {{ treaty.organization_b.name }}</div>
      <div class="text-h6">{{ treaty.name }}</div>
      <div class="text-caption">Created by: {{ treaty.creator_name }}</div>
      <div class="text-caption">Organization: {{ treaty.creator_organization_name }}</div>
      <div>{{ treaty.provisions.length }} Provisions</div>
    </q-card-section>
    <q-card-section>
      <q-btn class="full-width" @click="goto('/treaty/'+treaty.id)" color="primary" label="Visit" />
    </q-card-section>
    <q-card-section>
      <q-separator class="q-mt-sm q-mb-sm" />
      <div class="row">
        <div class="col">Yay: {{ treaty.yay_votes }} Nay: {{ treaty.nay_votes }}</div>
        <div class="col text-right">Rated {{ treaty.rating }}/5</div>
      </div>
    </q-card-section>
  </q-card>
</template>
<script>
export default {
  name: 'TreatyCardComponent',
  props: ['treaty'],
  components: {},
  data () {
    return {}
  },
  methods: {
    goto: function (url) {
      this.$router.push({ path: url })
    }
  },
  mounted () {}
}
</script>
