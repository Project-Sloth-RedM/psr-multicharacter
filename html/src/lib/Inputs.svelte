<script lang="ts">
	export let placeholder = 'placeholder';
	export let returnValue = '';
</script>

<main>
	<div class="container relative-position">
		<input bind:value={returnValue} {placeholder} type="text" />
	</div>
</main>

<style>
	input {
		background: url('../img/bg.png');
		border: none;
		outline-width: 0;
		text-align: center;
		color: white;
		font-size: 1.8vw;
		width: 25vw;
		background-repeat: no-repeat;
		background-size: cover;
	}
</style>
