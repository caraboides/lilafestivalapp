import 'package:flutter/material.dart';

import '../../../widgets/scaffold.dart';
import '../../../widgets/static_html_view.dart';
import 'faq.i18n.dart';

const String _faqHeader = '''
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css?family=Pirata+One&display=swap" rel="stylesheet">
    <style>
    h3 {
      font-family: 'Pirata One';
      font-size: 27px;
    }
    body {
      margin: 20px;
    }
    a:link, a:visited {
      color: #9da400;
    }
    </style>
    </head>
    ''';
const String _faq = '''
    <body>
        <div class="row"><div class="col-xs-12 col-sm-12 col-md-4">
<div id="c27" class="frame frame-default frame-type-text frame-layout-0"><header><h3 class="">
				Festival
			</h3></header><p>Das Party.San wird mit seiner 25. Auflage erneut auf dem Flugplatz Obermehler nahe der Stadt Schlotheim stattfinden. Da wir einen Flugplatz als Veranstaltungsareal nutzen, sind ein paar gesonderte Verhaltensregeln nötig, auf die wir noch genauer eingehen werden. Erneut werden wir&nbsp; die so genannte &nbsp;Underground - Bühne mit jeweils 5 Bands am Tag bespielen. Gesamt werden auf dem Party. San Open Air 2019 - 41 Bands auftreten. Wir hoffen natürlich, dass wir von Schäden, Unwettern &nbsp;und von Bandabsagen verschont bleiben. Das Party.San findet vom Donnerstag, 08.08.2019, bis Samstag, 10.08.2019, statt.</p></div>


<div id="c31" class="frame frame-default frame-type-text frame-layout-0"><header><h3 class="">
				Camping / Parken
			</h3></header><p>Der Zeltplatz ist ab Mittwoch, dem 07.08.2019, 10:00 Uhr geöffnet.</p><p>Der Campingplatz befindet sich direkt neben dem Festivalgelände.</p><p>Der Untergrund besteht aus befestigter/drainierter&nbsp; Wiese und ist relativ eben.</p><p>Es ist auf dem gesamten Campground und dem Festivalgelände untersagt:</p><ol start="1" type="1"><li>Lagerfeuer zu errichten&nbsp; - außer in speziell dafür vorgesehenen Behältern.</li><li>Das Graben von Löchern, wie zum Beispiel für Lagerstellen von Getränken usw.</li><li>Das Betreten des Flugplatzes außerhalb der bereitgestellten Flächen.</li><li>Beschädigungen an Leiteinrichtungen oder anderem Eigentum des Flugplatzbetreibers oder des Veranstalters.</li><li>Das Übersteigen und/oder Beschädigen von Zaunanlagen / Toren sowie aller anderen Sicherungsanlagen</li><li>Das gesamte Gelände ist mit einer max. Geschwindigkeit von 20 km/h zu befahren.&nbsp;</li></ol><p>Preissteigerungen, wie in den zurückliegenden Jahren, lassen sich auch auf die immer wieder aufgetretenen Beschädigungen zurückführen. Sollte es zu Schäden kommen, für die wir haftbar gemacht werden, müssen wir die Kosten wiederum auf die Preise im kommenden Jahr umlegen. Das Party.San versucht der Metal - Community eine faire Alternative zu bieten, dazu brauchen wir allerdings immer eure Unterstützung!</p><p>Das Fahrzeug&nbsp; kann direkt neben dem Zelt abgestellt werden. Ohne gültiges Ticket und der dazugehörigen Parkvignette ist das Betreten oder Befahren des gesamten Festivalgeländes incl. aller Zeltflächen nicht gestattet. Achtung! Private Stromaggregate sind nicht erlaubt!!!</p></div>

<div id="c591" class="frame frame-default frame-type-text frame-layout-0"><header><h3 class="">
				Gruppencamps
			</h3></header><p>Alle Camper, die in der Gruppe, größer 30 Personen, zusammen zelten möchten, Haben die Möglichkeit sich eine Campingfläche zu reservieren. Die reservierten Flächen unterliegen ausnahmslos unseren Sonderregeln GREEN CAMPING! Ihr müsst euch also entscheiden ob ihr diese Regeln befolgen könnt. Anfragen / Anmeldungen per Email an <a href="mailto:info@party-san.de">info@party-san.de</a> können bis zum <em><strong>21.06.2019</strong></em> an uns geschickt werden. Dabei sind diese Parameter zu beachten: Bitte schickt uns bei der Anmeldung die Infos für Punkt 1-7.</p><ol><li><p class="western">Bezeichnung der Gruppe / Fanclubname o.ä.</p></li><li><p class="western">Wie viele Autos</p></li><li><p class="western">Wie viele Zelte</p></li><li><p class="western">Wie viele Caravans</p></li><li><p class="western">Wie viele Personen (mind. 30 Personen)</p></li><li><p class="western">Für die Reservierung ist eine Bearbeitungsgebühr im Voraus von, 30-45 Pers. = 60,-€ 46-65 Pers. = 80,-€ / 66-100 Pers. = 100,-€) zu entrichten.</p></li><li><p class="western">Es besteht die Möglichkeit eine Mobiltoilette zu mieten, die dann direkt an eurem Camp stehen wird. Kosten dafür sind: 120,-€ (inkl. drei Reinigungen + 25,-€ Kaution).</p></li></ol><p>Da die Flächen für die Reservierung im letzten Jahr ausgebucht waren, kann es möglich sein, dass wir schon&nbsp;vor der Deadline ausgebucht sind. Daher bitten wir um schnelle Rückmeldung.</p><p>In der GREEN CAMPING AREA / reservierte Camping-Areale gelten einige besondere Campingregeln, die alle Besucher einhalten sollten, die in diesem Bereich campen wollen:</p><h3>Die neuen Richtlinien zu reservierten Flächen "green camping"!</h3><p>In der GREEN CAMPING AREA / reservierte Camping-Areale gelten einige besondere Campingregeln, die alle Besucher einhalten sollten, die in diesem Bereich campen wollen:</p><p>Die Sauberkeit des Camping -Areals liegt uns sehr am Herzen, daher fordern wir die Nutzer der reservierten Flächen auf, unnötige Campingutensilien gleich zuhause zu lassen und euren Zeltplatz während des Festivals weitestgehend sauber zu halten..</p><p>Zur Erleichterung der Abfallentsorgung werden in der Area an verschiedenen Punkten Sammelgefäße für Müll aufgestellt, die täglich, bei Bedarf auch mehrmals, entleert werden. Jeder Besucher erklärt sich bereit, die von ihm aufgestellten Zelte und Pavillons nach der Veranstaltung auch wieder mit nach Hause zu nehmen oder selbst in den vor Ort bereitgestellten Müllsammeltonnen zu entsorgen. Ihr stimmt überdies zu, am Abreisetag euren Restmüll vollständig an der Müllannahmestation abzugeben oder in den bereitgestellten Abfallbehältern zu entsorgen.</p><p>Es dürfen Zelte und Pavillons aufgebaut werden, aber keine sonstigen Bauten. Campingstühle sind natürlich zulässig, aber keine großen Möbel wie Sessel, Sofas, Betten und Kühlschränke. Das Mitbringen und der Betrieb von Stromaggregaten sind wie auf allen anderen Flächen untersagt. In der Zeit von 02:00 Uhr - 08:00 Uhr bitten wir, die Nachtruhe der Campingnachbarn zu respektieren. Das heißt nicht, dass auf den reservierten Flächen keine Musik gehört werden darf, sondern dass diese auf Wunsch der Nachbarschaft auf ein erträgliches Maß eingestellt werden muss.</p><p>Kommt es bei einzelnen Gruppen zu Verletzungen der Richtlinie, führt das zum dauerhaften Ausschluss aus den Reservierungsmöglichkeiten.</p></div>

</div><div class="col-xs-12 col-sm-12 col-md-4">
<div id="c34" class="frame frame-default frame-type-text frame-layout-0"><header><h3 class="">
				Bühnen
			</h3></header><p>Es wird wieder zwei Bühnen geben. Die erste ist die Hauptbühne, auf der ab Donnerstag die Bands spielen werden. Die zweite ist die Zeltbühne, diese wird 2014 erneut als zweite offizielle Bühne für täglich jeweils 5 Bands (Undergroundstage) genutzt. Weiter findet dort täglich die Aftershow- Party mit &nbsp;unseren beiden Radiosendern "The New Noise" &amp; "Hellborn Metal Radio" aus Thüringen statt. Da der Frühschoppen im letzten Jahr sehr gut angenommen wurde wird auch 2019 eine Band zu diesem Anlass aufspielen.</p></div>

<div id="c28" class="frame frame-default frame-type-text frame-layout-0"><header><h3 class="">
				Tickets
			</h3></header><p>Sichert euch euer Ticket im Vorverkauf! Auch unsere Kapazitäten sind nicht unendlich! Inwieweit es WE-Ticket/ Tagestickets an der Abendkasse geben wird, können wir zum jetzigen Zeitpunkt noch nicht sagen. Wir werden hierzu erst spätestens Mitte Juni eine Aussage treffen können.</p></div>

<div id="c33" class="frame frame-default frame-type-text frame-layout-0"><header><h3 class="">
				Müll
			</h3></header><p>Da das Party.San auf einer Flugbetriebsfläche stattfindet, ist noch stärker als bisher auf die Ordnung und Sauberkeit der Flächen bei der Abreise zu achten.
</p><p>Wir haben&nbsp; uns verpflichtet, den Campingflächen 2 Tage nach dem Festival gereinigt an den Eigentümer zu übergeben. Deshalb ist es unumgänglich eine Gebühr für das Parken und für die Müllentsorgung zu erheben. Diese wird für PKWs 10,00€ und für Caravans / Reisebusse oder Fahrzeuge mit Anhänger 20,-€ betragen. &nbsp;. Müllsäcke werden wie bisher weiterhin kostenlos ausgegeben und gegen Abgabe eines gut gefüllten Müllsackes wird es auch wieder unseren Party.San-Kalender geben. Wir hoffen auf euer Verständnis und bedanken und bei denen die ihren Platz sauber verlassen. 
</p><p>Außer für angemeldete Händler ist es auf dem gesamten Gelände verboten, mit Food/Nonfood Artikeln zu handeln.&nbsp;</p></div>

<div id="c30" class="frame frame-default frame-type-text frame-layout-0"><header><h3 class="">
				Kinder
			</h3></header><p>Kinder und Jugendliche (bis 16 Jahren) ohne erziehungsbeauftragte Person haben, laut JuSchG § 5, keinen Zutritt bei Konzert- und Tanz-Veranstaltungen. Jugendliche (ab 16 Jahre) ohne erziehungsbeauftragte Person haben bis 24:00 Uhr Zutritt bei o.g. Veranstaltungen.</p><p>Es gibt allerdings die Ausnahme, dass ihr mit dem &gt;&gt;&gt;<a href="http://download.party-san.com/pdf/PSOA2019_erziehungsberechtigte.pdf" title="Initiates file download" target="_blank">&nbsp;hier&nbsp;</a>&lt;&lt;&lt; zu ladenden Dokument einen Erziehungsbeauftragten benennen könnt. Füllt dazu das Dokument aus und lasst es von euren Eltern unterschreiben. Führt das Formular ständig mit euch und zeigt es auf Verlangen den Security -Mitarbeitern vor.</p><p>Die Zeiten, in denen ihr euch auf dem Festivalgelände aufhalten könnt, erhöhen sich dann wie folgt: bis 16 Jahre bis 24:00 Uhr / ab 16 Jahre bis euer Erziehungsbeauftragter euch den Aufenthalt untersagt.</p><p>Der Ausschank von alkoholischen Getränken an Kinder und Jugendliche unterliegt dem JuSchG. § 9.&nbsp;</p><p>In Begleitung von Erziehungsberechtigten haben Kinder und Jugendliche bis zum vollendeten 14. Lebensjahr freien Zutritt. Das heißt, wer 14 ist, muss bezahlen.&nbsp;</p></div>

<div id="c35" class="frame frame-default frame-type-text frame-layout-0"><header><h3 class="">
				Catering / Preise
			</h3></header><p>Eine Versorgung mit Getränken und Speisen ist ab Mittwochabend 20:00 Uhr bis Sonntagmorgen 11:00 Uhr möglich.<br>Wir achten streng darauf, nur Caterer zuzulassen, deren Produkte eine hohe Qualität besitzen. Die Versorgungspartner sind angewiesen, euch Speisen und Getränke zu einem vernünftigen Preis anzubieten. Der Getränkeausschank wird auch 2019 wieder von der alt bewerten Party.San-Crew sichergestellt.&nbsp;</p></div>

</div><div class="col-xs-12 col-sm-12 col-md-4">
<div id="c29" class="frame frame-default frame-type-text frame-layout-0"><header><h3 class="">
				Anreise Auto / Bahn
			</h3></header><p>Das Festivalgelände liegt ca. 20 km von den Autobahnanschlussstellen A38 (Abfahrt 10) - Sondershausen von Osten kommend und A38 (Abfahrt 6) - Leinefelde von Westen kommend.</p><p>Von Süden / Südwesten A71 (Abfahrt 4) - Erfurt Gispersleben - B4 bis Andisleben - L1042 bis Bad Langensalza - B84 bis Abzweig Schlotheim.</p><p>Die Anreise mit der Bahn ist auch kein Problem. Mühlhausen hat eine Direktverbindung nach Göttingen und Erfurt. Die ca. 15 km Strecke von Mühlhausen nach Schlotheim / Obermehler wird im Stundetakt durch den <a href="http://www.666tohell.de" title="Opens external link in new window" target="_blank" class="external-link-new-window">666 TO HELL</a> Bus und einen öffentlichen Überlandbus befahren. Der RIWA-Bus wird das gesamte Wochenende auch den Pendelverkehr zwischen Festivalgelände und Schlotheim übernehmen. Die&nbsp;<a href="/informationen/bus-shuttle/" title="Opens internal link in current window" class="internal-link">genauen Fahrzeiten</a>&nbsp;geben wir noch rechtzeitig auf der Internetseite bekannt. Es lässt sich aber schon absehen, dass dieser täglich um ca. 18:00 Uhr eingestellt wird und / oder noch einmal in der Nacht die Hotelschläfer nach Mühlhausen bringt.</p></div>


<div id="c778" class="frame frame-default frame-type-text frame-layout-0"><header><h3 class="">
				Mitfahrzentrale
			</h3></header><p>Fahrfahraway bietet euch die Möglichkeit kostengünstig und ohne eigenes Fahrzeug zum Festival zum kommen beziehungsweise euer fast leeres Auto mit Mitfahrern zu bestücken und eure Spritkosten zu senken. Kein Buchungssystem, keine Gebühren, Bargeldzahlung vor Ort - einfach, günstig &amp; gemeinsam reisen.</p><p><a href="https://fahrfahraway.com/event/59-partysan-metal-open-air" target="_blank">https://fahrfahraway.com/event/59-partysan-metal-open-air</a>&nbsp;</p></div>

<div id="c32" class="frame frame-default frame-type-text frame-layout-0"><header><h3 class="">
				Toiletten / Duschen / Versorgung
			</h3></header><p>Es werden ausreichend kostenlose Mobil -Toiletten vorhanden sein. Diese befinden sich gut sichtbar unmittelbar bei den Lichttürmen auf der Landebahn. Die Toiletten werden während des Festivals mehrmals täglich gereinigt. Wie auch im letzten Jahr wird es zwei Sanitärstützpunkte mit Spültoiletten und Duschen geben. Diese befinden sich ebenfalls gut sichtbar auf den Zeltplatzflächen (Süd). Es wird auch wieder das so genannte Flatrate- Ticket für die Benutzung der Toiletten und Duschen geben. Dieses könnt ihr direkt an den Servicepunkten erwerben.</p><p>Handwaschgelegenheiten und Wasserentnahmestellen wird es selbstverständlich auf dem Campinggelände in der Nähe der Servicepunkte geben.&nbsp;</p><p>Zwischen Festivaleinlass und Backstage- Einfahrt befindet sich zusätzlich zum bekannten Frühstückzelt ein Biergarten, der ab Mittwochabend geöffnet ist. Das Partyzelt ist ab Mittwoch,&nbsp; 07.08.2019, 20:00 Uhr geöffnet und wird, wie auch in den vergangenen Jahren, nicht mehr durchgehend geöffnet sein, sondern öffnet parallel zum Festivalgelände seine Tore. Natürlich wird es auch weiterhin die täglichen Aftershowparties geben, für die das Party.San- Partyzelt mittlerweile berüchtigt ist.</p></div>

<div id="c36" class="frame frame-default frame-type-text frame-layout-0"><header><h3 class="">
				Mitbringsel
			</h3></header><p>Waffen, Feuerwerkskörper, Artikel aus Glas sind absolut verboten. Es wird <br> dieses Jahr wieder bei Anreise kontrolliert. Bei erheblichen Verstößen kann ein Platzverweis ausgesprochen werden. Also lasst den Kram zu Hause!
</p><p>GASFLASCHEN:&nbsp; Gasflaschen sind auf dem Party.San Open Air nicht verboten. In Einzelfällen kann jedoch das Security - Personal &nbsp;mitgeführte Gasflaschen beschlagnahmen. Diese werden natürlich nach Ende der Veranstaltung an die Besitzer zurückgegeben. 
</p><p>Dies gilt im Besonderen wenn: &nbsp;</p><ul><li>die Gasflasche eine größere Füllmenge als 5 Kg hat. Maximal eine Flasche pro Fahrzeug !!</li><li>die Gasflasche keine aktuelle TÜV - Prüfung hat (Stempel oder Schild an Gasflasche)</li><li>kein Druckregler oder Anschlussschläuche&nbsp; mit gültigen TÜV vorweisbar sind. (Stempel und /oder Aufdruck )</li><li>bei der betriebenen Gasanlagen keine funktionssichere Zündsicherung vorhanden ist.</li><li>bei Betrieb im Wohnwagen / Wohnmobilen keine gültige Gasprüfung vorliegt. &nbsp;(TÜV Plakette) &nbsp; &nbsp;</li></ul></div>

</div></div>
</body>
''';

const String _faqEn = '''
<body>
<div class="row"><div class="col-xs-12 col-sm-12 col-md-4">
<div id="c27" class="frame frame-default frame-type-text frame-layout-0"><a id="c44"></a><header><h3 class="">
				Festival
			</h3></header><p>The airfield Obermehler near the city of Schlotheim is for the second time home of the Party.San festival, edition 25. Because of using an airfield area some special codes of behaviour are necessary. Details later. For the first time ever we present the so-called underground stage with five bands a day. Altogether 41 bands play the Party.San in 2019. Naturally we hope being spared from damages, severe wheater and band refusals. Party.San takes place from 08.08.2019 to 10.08.2019.</p></div>

<div id="c31" class="frame frame-default frame-type-text frame-layout-0"><a id="c45"></a><header><h3 class="">
				Camping / Parking
			</h3></header><p>The camping area is located next to the festival area and opens wednesday 07.08.2019 at 10am.</p><p>The soil is of solid, drained and nearly plane ground.</p><p>Parking on the festival area costs 10€ (parking/garbage fee) for every vehicle with more than two wheels.</p><p>Forbidden:</p><ol><li>Lighting a camp fire - except in special boxes for designated use.</li><li>Digging holes, such as to store beverages etc.</li><li>Trespassing the airfield outside the provided area.</li><li>Damaging technical facilities or other properties of the airfield operator or organizer.</li><li>Hopping and/or damaging fences, gateways or other securing devises.</li><li>Fixing steel bolts to secure tents etc. that can´t or won´t be removed.</li><li>The German road-traffic regulations (StVO) apply throughout the entire area - maximum speed allowed 20&nbsp;km/h.&nbsp;</li></ol><p>If we should be held liable in the event of damages, we have to allocate expenses. In consequence you have to accept higher prices. Party.San tries to offer a fair alternative to the metal community but it will not work without the support of the community.</p><p>You can park your car next to your tent. Entering the entire festival area including camping area by foot or car without valid ticket and the appropriate parking vignette is strictly forbidden.</p><p>Attention! Private power sets are strictly forbidden!&nbsp;</p></div>

<div id="c591" class="frame frame-default frame-type-text frame-layout-0"><a id="c594"></a><header><h3 class="">
				Bigger groups
			</h3></header><p>All campers who want to camp together in groups with more than 30 persons are able to make a reservation for a camping ground. Thats why we have established special rules for camping on reserved areas (see below). You have to follow these rules without exception. No exceptions. For inquiries and registrations please mail to info@party-san.de. Deadline: <strong>June 21th 2019</strong>. Please fill in:</p><ol><li>Name of the group or fan club</li><li>Number of cars</li><li>Number of tents</li><li>Number of caravans</li><li>Number of persons (minimum 30)</li><li>We charge a reservation fee only payable in advance (30 to 45 persons: € 60,- / 46 to 65 persons: € 80,- / 66 to 100 persons: € 100,-)</li><li>It is also possible to rent a private/portable toilet for your camp area. Fee: € 120,- (including 3 times cleaning plus deposit € 25,-)</li></ol><p>Please book as soon as you can since all camps have been sold out in 2017. We expect that all capacities will be gone very quickly.</p><h3>Please note the new instructions for the reserved areas at our "green camping"!</h3><p>We have established a special protocol for the GREEN CAMPING AREA – you have to stick to the protocol without exceptions.</p><p>We really care about the cleanliness of the camping area, that is why we request the campers of the reserved areas to leave unnecessary utensils at home and to keep your camping site mostly clean during the festival.</p><p>For a better handling of the waste disposal we will place containers in various sectors of the area. They will be emptied out several times a day if necessary. Every visitor agrees either to take back home his tents and pavilions or to dispose it. For disposal use the provided containers only. Furthermore you agree to deliver your entire residual waste to the waste station. For disposal use the provided containers only.</p><p>Note: Only regular tents and pavilions are permitted. Please leave your furniture such as wooden chairs, sofas, beds or fridges at home. Bringing along or using power generators is strictly prohibited throughout the whole camping area. Please keep the night time peace between 2 and 8 a.m. and respect the sleep of your neighbours. Keep your music down and prevent noisy parties. You are at a Green Camping Ground.</p><p>These rules must be strictly observed and any offense leads to the exclusion of the campground.</p></div>

</div><div class="col-xs-12 col-sm-12 col-md-4">
<div id="c34" class="frame frame-default frame-type-text frame-layout-0"><a id="c46"></a><header><h3 class="">
				Stages
			</h3></header><p>Again we have two stages. Bands play the main stage from thursday on. Stage two is the tent stage, where we present for the first time a second official stage (underground stage) for five bands a day. The tent stage is also in use for our aftershow parties supported by our two thuringian radio stations "The New Noise" and "Hellborn Metal Radio". The morning pint has proved very popular last year, so in 2019 a band is playing again on this occasion.</p></div>

<div id="c28" class="frame frame-default frame-type-text frame-layout-0"><a id="c40"></a><header><h3 class="">
				Tickets
			</h3></header><p>Get your tickets in advance! We do not have endless capacities! At the moment we can not make a statement about availabilities of weekend or day tickets at the box office. At the end of June we are able to say something about it.</p></div>

<div id="c33" class="frame frame-default frame-type-text frame-layout-0"><a id="c42"></a><header><h3 class="">
				Garbage
			</h3></header><p>Party.San takes place on an airfield area. That´s why we have to take care for order and cleanliness of the grounds during the departure stricter than ever before.</p><p>We have commited ourselves to pass the camping area cleaned to its owner two days after the festival. We can not realise it only with our crew as before. I.e. we have to hire a well rewarded specialist company. So there is no other way than to charge a fee for parking and garbage disposal. The fee for cars will be 10 Euros. For caravans/motorhomes, coaches or cars with trailers there will be a 20 Euros fee. Garbage bags are distributed as before. Of course you get the Party.San calendar if you give it back well-filled. We thank you for your understanding, especially all the people who leave their ground clean.</p></div>

<div id="c30" class="frame frame-default frame-type-text frame-layout-0"><a id="c41"></a><header><h3 class="">
				Children and juveniles
			</h3></header><p>Children and juveniles (up to 16) without legal guardian are not admitted to concert or dance events by german law (JuSchG. §9). Juveniles (16 and older) without legal guardian have access to events mentioned above until midnight.</p><p>Even so there is one exception. Download this document &gt;&gt;&gt;<a href="http://download.party-san.com/pdf/PSOA2019_erziehungsberechtigte_EN.pdf" title="Initiates file download" target="_blank">&nbsp;here&nbsp;</a>&lt;&lt;&lt; and name a legal guardian. Complete the&nbsp; form and get a sign from your parents or legal guardian. Have this document with you all the time and show it to security if requested.</p><p>Your are allowed to stay at the festival area as long as follows: up to 16 until midnight / 16 and older until your legal guardian vetoes.</p><p>Service of alcohol to children and juveniles is subject to german law (JuSchG. § 9).</p><p>Children and juveniles under 14 accompanied by a legal guardian are admitted free of charge. I.e. you have to pay if you are 14 and older.</p></div>

<div id="c35" class="frame frame-default frame-type-text frame-layout-0"><a id="c43"></a><header><h3 class="">
				Catering / Prices
			</h3></header><p>Food and drink supply is guaranteed from wednesday 7pm to sunday morning 11am.</p><p>We pay strict attention to high quality catering. Our catering partners have order to provide affordable food and drinks. Our tried and trusted Party.San crew takes care for your drinks once again.</p></div>

</div><div class="col-xs-12 col-sm-12 col-md-4">
<div id="c29" class="frame frame-default frame-type-text frame-layout-0"><a id="c37"></a><header><h3 class="">
				Arrival by car or train
			</h3></header><p>The festival area is located approx. 20 km away from autobahn A38 exit Sondershausen (exit 10) - coming from the east - and A38 exit Leinefelde (exit 6) - coming from the west.</p><p>Coming from a south/southwest direction take the A71 exit Erfurt Gispersleben (exit 4) - B4 to Andisleben - L1042 to Bad Langensalza and finally B84 until exit Schlotheim.</p><p>Arrival by train is also trouble-free. Mühlhausen station is directly connected to Göttingen and Erfurt stations. The approx. 15 km way from Mühlhausen to Schlotheim/Obermehler is frequented hourly by the "<a href="http://www.666tohell.de" title="Öffnet externen Link in neuem Fenster" target="_blank" class="external-link-new-window">666 TO HELL</a>" shuttle bus or the public country bus. The "<a href="http://www.666tohell.de" title="Öffnet externen Link in neuem Fenster" target="_blank" class="external-link-new-window">666 TO HELL</a>" bus also shuttles between festival area and the city of Schlotheim during the whole weekend. The&nbsp;<a href="/en/informationen/bus-shuttle/" title="Opens internal link in current window" class="internal-link">schedule</a>&nbsp;is announced in time on our website. It is not difficult to foresee that the shuttle service will be abandoned approx. 9pm. About 2am a very last shuttle brings home Mühlhausen hotel guests.</p></div>

<div id="c778" class="frame frame-default frame-type-text frame-layout-0"><a id="c780"></a><header><h3 class="">
				Carsharing
			</h3></header><p>Fahrfahraway offers you the opportunity to travel to the festival without your own vehicle or to fill your almost empty car with passengers and reduce your fuel costs. No booking system, no fees, cash payment on site - easy, cheap &amp; collective travelling.</p><p><a href="https://fahrfahraway.com/event/59-partysan-metal-open-air" target="_blank">https://fahrfahraway.com/event/59-partysan-metal-open-air</a>&nbsp;</p></div>

<div id="c32" class="frame frame-default frame-type-text frame-layout-0"><a id="c38"></a><header><h3 class="">
				Toilets / Showers / Supply
			</h3></header><p>There will be enough free-to-use portable toilets in place. These are located next to the light towers on the runway and can be easily seen. The toilets will be cleaned daily several times. As last year we provide two sanitary bases with flush toilets and showers. The bases are located on the camping area (south) next to the runway and can be easily seen, too. The so-called flatrate ticket for using both toilets and showers is available again. Get it at service points or box office.</p><p>Of course there will be facilities for hand washing and water intake on the camping ground next to service points.</p><p>Located between main and backstage entrance you can find a beer garden in addition to the wellknown breakfast tent, opened from wednesday evening. The party tent opens from thursday August 8, daily between 7pm and 3am. Of course we stage our notorious daily after show parties.</p></div>

<div id="c36" class="frame frame-default frame-type-text frame-layout-0"><a id="c39"></a><header><h3 class="">
				(Not) To bring along
			</h3></header><p>Weapons, pyrotechnic articles and glassware is strictly prohibited. As every year we have controls at the festival entrance. Considerable violation of the rules may lead to a sending off. About glassware: all forbidden items made of glass (even nutella or gherkin jars) found at the control are withdrawn and destroyed without replacement!</p><p>Please leave this shit at home!<br><br>GAS CYLINDERS:&nbsp; Gas cylinders are not prohibited at Party.San Metal Open Air. In individual cases the security staff can seize the gas cylinders which are brought by you. Of course you will get them back after the festival.&nbsp;<br><br>This applies in particular if:</p><ul><li>the filling quanitity of the gas cylinder exceeds 5kg. Only one gas cylinder per car is allowed.</li><li>the gas cylinder has no valid TÜV-certificate (TÜV = German Association for Technical Inspection) (stamp or sign on the gas cylinder)</li><li>you cannot show a valid TÜV-certificate for the pressure regulator and/or the connecting hose that will be used (stamp or imprint)</li><li>the gas installation has no functional reliable safety pilot</li><li>the gas installation operating in a caravan/motorhome has no valid gas test (TÜV badge)</li></ul><p>Dealing with food/non-food articles without license is strictly forbidden on the festival grounds for anyone but registered traders.</p><p>Some words about the unwelcomed issue of political acting and showcasing of political excesses. The shirt ban for national socialist and/or NSBM motives remains in force! The ban is valid for the entire festival and camping area. In fact we see a remarkable improvement over the last years but we have to make clear that we don´t tolerate political shit or the slightest provocation either! This is something for all sides of political display. Raw offenses always involve a report to the police.&nbsp;</p></div>

</div></div>
</body>
''';

class FAQ extends StatelessWidget {
  const FAQ();

  static Widget builder(BuildContext context) => const FAQ();

  static String title() => 'FAQ'.i18n;

  String _buildHtml(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return _faqHeader + (locale.languageCode == 'en' ? _faqEn : _faq);
  }

  @override
  Widget build(BuildContext context) => AppScaffold.withTitle(
        title: title(),
        body: StaticHtmlView(_buildHtml(context)),
      );
}
