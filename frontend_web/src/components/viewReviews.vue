<template>
  <div class="review-list" v-if="reviewsExist">
    <div class="card" v-for="(review, index) in reviews" :key="index">
      <div class="card-header">
        <h3>{{ review.date }}</h3>
      </div>
      <div class="card-body">
        <p>{{ review.description }}</p>
      </div>
    </div>
  </div>
  <h2 v-else>No Reviews Exist</h2>
</template>
<script>
export default {
  name: "viewReviews",
  props: ["reviews"],
  computed: {
    reviewsExist() {
      return this.reviews.length > 0;
    },
  },
};
</script>
<style lang="scss" scoped>
.review-list {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
}

.card {
  background-color: white;
  border: 1px solid #ccc;
  border-radius: 0.5rem;
  box-shadow: 0 2px 2px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 400px;
}

.card-header {
  background-color: #f7f7f7;
  //   padding: 0.5rem;
  border-bottom: 1px solid #ccc;
}

.card-header h3 {
  margin: 0;
  font-size: 1.2rem;
}

// .card-body {
//   padding: 1rem;
// }

.card-body p {
  margin: 0;
  font-size: 1rem;
  line-height: 1.5;
}
</style>
