<script lang="ts">
	export let newPlayer = (i: number): void => {};
	export let i = 0;
</script>

<div class="container relative-position" style:width="20vw">
	<div on:click={() => newPlayer(i)}>
		<div class="flex">
			<div class="texto fit" style="align-items:center;top:0;">
				<p>New Player</p>
				<br />
			</div>
		</div>
		<img class="img" style="width:100%;" src="img/inputg.png" alt="" />
	</div>
</div>

<style>
	.texto {
		position: absolute;
		font-style: normal;
		font-weight: 400;
		font-size: 2vw;
		display: flex;
		align-items: flex-end;
		top: 2vh;
		justify-content: center;
		color: #000000;
	}
</style>
