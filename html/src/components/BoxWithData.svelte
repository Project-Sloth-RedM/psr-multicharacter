<script lang="ts">
	export let name = '';
	export let citizenID = '';
	export let i = null;
	export let ss = null;
	export let onSelectedCitizenid = (citizenID: string): void => {};
</script>

<div class="container relative-position scroll hide-scrollbar" on:click={() => onSelectedCitizenid(citizenID)} style:width={'20vw'}>
	<div class="relative-position fit scroll hide-scrollbar ">
		<div class="absolute-center full-width">
			<div class="texto " style="width:100%;height:100%">
				<p class="ellipsis " style={ss === i ? 'color:white;' : 'color:black;'}>{name}</p>
				<br />
			</div>
			<div class="textos fit">
				<p class="ellipsis" style={ss === i ? 'color:white;' : 'color:black;'}>{citizenID}</p>
				<br />
			</div>
		</div>
		<!-- {#if ss === i}
			<div on:click={() => onArrowClick(citizenID)} class="absolute-right imgs" style:top="4vh" style:right="2vh">
				<img src="img/arrowr.png" style:width={'2rem'} alt="" />
			</div>
			<div class="absolute-left imgs" style:top={'4vh'} style:left="2vh">
				<img src="img/x.png" alt="" style:width={'2rem'} />
			</div>
		{/if} -->
		<img style="width:20vw;" src={ss === i ? 'img/toast.png' : 'img/inputgold.png'} alt="" />
	</div>
</div>

<style>
	.texto {
		position: absolute;
		font-style: normal;
		font-weight: 400;
		font-size: 2.2vw;
		color: #000000;
		text-shadow: 2px 2px rgba(14, 13, 13, 0.325);
		width: 77%;
		display: flex;
		top: 2.1vh;
		align-items: flex-end;
		text-align: center;
		justify-content: center;
		text-overflow: ellipsis;
	}
	.textos {
		position: absolute;
		font-style: normal;
		font-weight: 400;
		font-size: 1.5vw;
		display: flex;
		align-items: flex-start;
		top: 0vh;
		justify-content: center;
		color: #000000;
	}
</style>
