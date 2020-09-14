<template>
  <div class="text-center">
    <h1 class="text-light">CONCORDANT.IO</h1>
    <h4 class="q-mb-sm">The treaty building platform</h4>
    <q-btn class="q-mb-sm" color="dark full-width">GET STARTED</q-btn>
    <p>Giving PEACE a chance.</p>
  </div>
</template>
<script>
export default {
  meta () {
    return {}
  },
  name: '',
  components: {},
  data () {
    return {}
  },
  methods: {},
  mounted () {},
  beforeCreate: function () {
    document.body.className = 'grad'
  }
}

</script>
<style>
.grad {
  background: linear-gradient(-145deg, #00f185, #ee7702, #e73c7e, #193c6d, #23d5ab);
  background-size: 700% 700%;
  animation: gradient 16s ease infinite;
}
@keyframes gradient {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}
</style>
