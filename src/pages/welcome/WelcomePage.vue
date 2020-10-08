<template>
  <div class="activity-width">
    <div class="q-pt-md q-pt-lg">
      <h3 class="q-pa-none">Welcome to Concordant.io</h3>
    </div>
    <h6 class="q-pt-sm">How to interact with the website:</h6>
    <q-separator />
    <ul class="q-mt-lg">
      <li>
        <h5>1. Conflicts</h5>
        <p>Each conflict is between two organizations that have problems to resolve.</p>
      </li>
      <li>
        <h5>2. Grievances</h5>
        <p>Describe and prioritize issues between the organizations. </p>
      </li>
      <li>
        <h5>3. Offers</h5>
        <p>These are potential concessions to broker a successul treaty.</p>
      </li>
      <li>
        <h5>4. Topics</h5>
        <p>Post your thoughts and ideas. We ask members to stay civil and respectable.</p>
      </li>
      <li>
        <h5>5. Treaties</h5>
        <p>A successful treaty is when a majority of voters from both organizations vote YAY.</p>
      </li>
    </ul>
    <q-separator />
    <div class="q-mt-lg q-mb-sm">
      <h5>Site Rules:</h5>
      <ul style="list-style-type:bullets;" class="q-pl-md">
        <li>Be courteous and professional</li>
        <li>Do not misrepresent yourself</li>
        <li>Be honest and practice integrity</li>
      </ul>
    </div>
    <q-separator />
    <div class="q-mt-lg q-mb-sm">
      <h5 class="q-pa-none q-ma-none">Next steps...</h5>
    </div>
    <p class="q-mb-lg q-mt-lg">
      <router-link to="/login"><q-btn class="full-width" icon="login" color="primary" label="Step one is signup or login" /></router-link>
    </p>
    <h6>Join an organization</h6>
    <ul class="q-mb-lg">
      <li v-for="org in organizations" :key="org.id"><router-link :to="'/organization/'+org.id">{{ org.name }}: {{ org.description }}</router-link></li>
      <li class="q-pt-md"><router-link to="/organizations"><q-btn class="full-width" color="accent" label="View all organizations" /></router-link></li>
    </ul>
    <q-space />
    <h6>Review a conflict</h6>
    <ul class="q-mb-lg">
      <li v-for="conflict in conflicts" :key="conflict.id"><router-link :to="'/conflict/'+conflict.id">{{ conflict.name }}</router-link></li>
      <li class="q-pt-md"><router-link to="/conflicts"><q-btn class="full-width" color="accent" label="View all conflicts" /></router-link></li>
    </ul>
    <q-space />
    <h6>Create a treaty</h6>
    <ul class="q-mb-lg q-pb-lg">
      <li v-for="treaty in treaties" :key="treaty.id"><router-link :to="'/treaty/'+treaty.id">{{ treaty.name }}</router-link></li>
      <li class="q-pt-md"><router-link to="/treaties"><q-btn class="full-width" color="accent" label="View all treaties" /></router-link></li>
    </ul>
    <q-space />
    <h6>Check site activity</h6>
    <ul class="q-mb-lg q-pb-lg">
      <li class="q-pt-md"><router-link to="/activity"><q-btn class="full-width" color="accent" label="Site activity" /></router-link></li>
    </ul>
  </div>
</template>
<script>
export default {
  meta () {
    return {
      title: 'Welcome to Concordant.io'
    }
  },
  name: 'WelcomePage',
  components: {},
  data () {
    return {
      organizations: [],
      conflicts: [],
      treaties: [],
      limit: 5,
      pointer: 0
    }
  },
  methods: {
    getItems: function () {
      const entities = ['conflicts', 'organizations', 'treaties']
      entities.forEach(this.query)
    },
    query: async function (entityName) {
      const q = `${process.env.api}/${entityName}?filter[limit]=${this.limit}&filter[skip]=${this.pointer}`
      const res = await this.$axios.get(q)
      this[entityName] = res.data
    }
  },
  mounted () {
    this.getItems()
  }
}
</script>
