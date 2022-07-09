import {get, writable} from 'svelte/store';
import type {Writable} from 'svelte/store';
import {fetchNui} from '../utils/eventHandler';
import DebugStore from './debugStore';
import {menuStoreLocalStorageName} from '../types/types';
import {saveUIDataToLocalStorage} from '../utils/eventHandler';
import PlayerHudStore from '../stores/playerStatusHudStore';
import {FunctionDefaultStore} from '../utils/defaultStore';
import type {DefaultStoreType} from '../utils/defaultStore';

interface menuStatus {
	show: Writable<boolean>;
	showLogo: Writable<boolean>;
	adminOnly: Writable<boolean>;
	isAdmin: Writable<boolean>;
	isRestarting: Writable<boolean>;
	isCineamticModeChecked: DefaultStoreType<boolean>;
	isCinematicNotifyChecked: DefaultStoreType<boolean>;
	isCompassFollowChecked: DefaultStoreType<boolean>;
	isMapEnabledChecked: DefaultStoreType<boolean>;
	isListSoundsChecked: DefaultStoreType<boolean>;
	isLowFuelAlertChecked: DefaultStoreType<boolean>;
	isMapNotifyChecked: DefaultStoreType<boolean>;
	isOpenMenuSoundsChecked: DefaultStoreType<boolean>;
	isOutCompassChecked: DefaultStoreType<boolean>;
	isOutMapChecked: DefaultStoreType<boolean>;
	isPointerShowChecked: DefaultStoreType<boolean>;
	isResetSoundsChecked: DefaultStoreType<boolean>;
	isShowCompassChecked: DefaultStoreType<boolean>;
	isShowRadioChannelChecked: DefaultStoreType<boolean>;
	isShowStreetsChecked: DefaultStoreType<boolean>;
	isToggleMapBordersChecked: DefaultStoreType<boolean>;
	isToggleMapShapeChecked: DefaultStoreType<'circle' | 'square'>;
}

const store = () => {
	let stored: string = localStorage.getItem(menuStoreLocalStorageName);
	let storedObject: object = {};
	if (stored) {
		storedObject = JSON.parse(stored);
	}

	function getLocalStorage(key: string, fallback: any) {
		if (storedObject && storedObject[key] != null) {
			return storedObject[key];
		}
		return fallback;
	}

	const menuStatusState: menuStatus = {
		show: writable(false || DebugStore),
		showLogo: writable(true),
		adminOnly: writable(false || DebugStore),
		isAdmin: writable(false || DebugStore),
		isRestarting: writable(false),
		isCineamticModeChecked: FunctionDefaultStore(() => getLocalStorage('isCineamticModeChecked', false)),
		isCinematicNotifyChecked: FunctionDefaultStore(() => getLocalStorage('isCinematicNotifChecked', true)),
		isCompassFollowChecked: FunctionDefaultStore(() => getLocalStorage('isCompassFollowChecked', true)),
		isMapEnabledChecked: FunctionDefaultStore(() => getLocalStorage('isHideMapChecked', true)),
		isListSoundsChecked: FunctionDefaultStore(() => getLocalStorage('isListSoundsChecked', true)),
		isLowFuelAlertChecked: FunctionDefaultStore(() => getLocalStorage('isLowFuelChecked', true)),
		isMapNotifyChecked: FunctionDefaultStore(() => getLocalStorage('isMapNotifChecked', true)),
		isOpenMenuSoundsChecked: FunctionDefaultStore(() => getLocalStorage('isOpenMenuSoundsChecked', true)),
		isOutCompassChecked: FunctionDefaultStore(() => getLocalStorage('isOutCompassChecked', true)),
		isOutMapChecked: FunctionDefaultStore(() => getLocalStorage('isOutMapChecked', true)),
		isPointerShowChecked: FunctionDefaultStore(() => getLocalStorage('isPointerShowChecked', true)),
		isResetSoundsChecked: FunctionDefaultStore(() => getLocalStorage('isResetSoundsChecked', true)),
		isShowCompassChecked: FunctionDefaultStore(() => getLocalStorage('isShowCompassChecked', true)),
		isShowRadioChannelChecked: FunctionDefaultStore(() => getLocalStorage('isShowRadioChannelChecked', false)),
		isShowStreetsChecked: FunctionDefaultStore(() => getLocalStorage('isShowStreetsChecked', true)),
		isToggleMapBordersChecked: FunctionDefaultStore(() => getLocalStorage('isToggleMapBordersChecked', true)),
		isToggleMapShapeChecked: FunctionDefaultStore(() => getLocalStorage('isToggleMapShapeChecked', 'circle')),
	};

	const methods = {
		closeMenu() {
			menuStatusState.show.set(false);
			fetchNui('closeMenu');
		},
		getSaveableData() {
			let saveableObject = {};
			const ignoreKeys: Array<string> = ['show', 'showLogo', 'adminOnly', 'isAdmin'];
			for (const [key, store] of Object.entries(menuStatusState)) {
				if (!ignoreKeys.includes(key)) {
					saveableObject[key] = get(store);
				}
			}
		},
		handleKeyUp(data) {
			if (data.key == 'Escape') {
				saveUIDataToLocalStorage();
				methods.closeMenu();
			}
		},
		openMenu() {
			menuStatusState.show.set(true);
		},
		receiveMessage() {
			methods.openMenu();
		},
		receiveAdminMessage(data: {adminOnly: boolean; isAdmin: boolean}) {
			menuStatusState.adminOnly.set(data.adminOnly);
			menuStatusState.isAdmin.set(data.isAdmin);
		},
		receiveRestartMessage() {
			menuStatusState.isRestarting.set(false);
		},
		resetHudMenuSettings() {
			storedObject = {};
			localStorage.removeItem(menuStoreLocalStorageName);

			for (const store of Object.values(menuStatusState)) {
				if (store.resetValue) {
					store.resetValue();
				}
			}
			// Call PlayerStatus Reset Dynamic icon settings to false
			PlayerHudStore.updateAllShowingDynamicIcons(false);
		},
		saveUIDataToLocalStorage() {
			const data = methods.getSaveableData();
			localStorage.setItem(menuStoreLocalStorageName, JSON.stringify(data));
		},
		sendMenuSettingsToClient() {
			fetchNui('updateMenuSettingsToClient', methods.getSaveableData())
				.then((data: any) => {
					if (data) {
					}
				})
				.catch(() => {});
		},
	};

	// Upon loading into server send the client the menu settings data
	//  to be in sync with the ui settings
	methods.sendMenuSettingsToClient();

	return {
		...menuStatusState,
		...methods,
	};
};

export default store();
