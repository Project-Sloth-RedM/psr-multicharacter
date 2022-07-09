import {writable} from 'svelte/store';
import {fetchNui} from '../utils/fetchNui';
import {isEnvBrowser} from '../utils/misc';

interface characterInfo {
	citizenid: string;
}

const store = () => {
	const sCharacter: string = '';
	const {subscribe, set, update} = writable(sCharacter);
	let cache = '';
	return {
		subscribe,
		set,
		update,
		async sendSelectedCharacter(character: string) {
			if (cache !== character) {
				if (!isEnvBrowser()) {
					await fetchNui('selectedCharacter', {citizenid: character});
					cache = character;
				}
			}
		},
		async spawnSelectedCharacter(cid: string, location: string) {
			if (!isEnvBrowser()) {
				await fetchNui('spawnSelectedCharacter', {citizenid: cid, location: location});
				cache = '';
			}
		},
		async onCharacterDelete(cid: string) {
			if (!isEnvBrowser()) {
				await fetchNui('deleteCurrentCharacter', {citizenid: cid});
				cache = '';
			}
		},
	};
};
export default store();
