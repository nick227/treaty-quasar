<template>
  <q-item class="full-width q-mb-lg">
    <q-card class="full-width">
      <div class="text-h4 q-pa-md">{{ treaty.name }}</div>
      <q-img @click="goto('/treaty/'+treaty.id)" clickable v-ripple class="cursor-pointer" :src="treaty.avatar_url"></q-img>
      <div class="q-pl-md bg-grey-3">{{ treaty.organization_a.name }} vs. {{ treaty.organization_b.name }}</div>
      <q-card-section>
        <q-btn align="around" class="float-right text-black" @click="goto('/treaty/'+treaty.id)" color="white" label="Visit" icon="launch" />
        <div class="caption">Created by: {{ treaty.creator_name }}</div>
        <div>Organization: {{ treaty.creator_organization_name }}</div>
        <q-separator class="q-mt-sm q-mb-sm" />
        <p class="q-pa-none">{{ treaty.description }}</p>
        <q-separator class="q-mt-sm q-mb-sm" />
        <div class="row">
          <div class="col">Yay: {{ treaty.yay_votes }} Nay: {{ treaty.nay_votes }}</div>
          <div class="col text-right">Rated {{ treaty.rating }}/5</div>
        </div>
      </q-card-section>
      <q-expansion-item class="bg-blue-grey-5" switch-toggle-side dense-toggle :label="'Provisions ' + treaty.provisions.length">
        <div class="q-pl-lg q-pt-sm q-pr-lg q-pb-sm" v-for="(provision, i) in treaty.provisions" :key="provision.id"><q-badge class="q-mr-sm" color="grey">{{ i + 1 }}</q-badge> {{ provision.title }}</div>
      </q-expansion-item>
    </q-card>
  </q-item>
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
