FROM dorowu/ubuntu-desktop-lxde-vnc:focal
EXPOSE 8555
EXPOSE 8444
EXPOSE 8447
EXPOSE 80
ENV KEYS="generate"
ENV PLOTS_DIR="/plots"
ENV USER="chia"
ENV HTTP_PASSWORD="Ek32zv"
ENV PASSWORD="Ek32zv"
ARG BRANCH
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y git lsb-release
RUN echo "cloning $BRANCH"
WORKDIR /
RUN git clone https://github.com/Chia-Network/chia-blockchain.git -b latest --recurse-submodules
RUN git clone --branch v.0.1.0 https://github.com/swar/Swar-Chia-Plot-Manager.git
ADD ./config.yaml /Swar-Chia-Plot-Manager/config.yaml
WORKDIR /chia-blockchain
RUN git submodule update --init mozilla-ca \
&& chmod +x install.sh \
&& sh ./install.sh
ADD ./entrypoint.sh entrypoint.sh
ADD ./chia-gui.desktop /usr/share/applications/chia-gui.desktop
ADD ./chia-manager.desktop /usr/share/applications/chia-manager.desktop
ADD ./runGUI.sh runGUI.sh
ADD ./runPlotManager.sh runPlotManager.sh
ADD ./setupPlotManager.sh setupPlotManager.sh
ADD ./chiaSetup.sh chiaSetup.sh
RUN chmod +x ./runGUI.sh && chmod +x ./runPlotManager.sh
RUN chmod +x ./setupPlotManager.sh && ./setupPlotManager.sh $USER
RUN chmod +x ./chiaSetup.sh
ENTRYPOINT ["./entrypoint.sh"]
